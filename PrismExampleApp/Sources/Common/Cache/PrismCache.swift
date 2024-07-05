/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

class PrismCache: ObservableObject {
    private let fileManager = FileManager.default
    private let cacheName: String = "Prism"
    @Published var cache: [PrismObject] = []

    var cacheDirectory: URL? {
        guard let documentsDirectory: URL = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let directory = documentsDirectory.appendingPathComponent(self.cacheName)
        return directory
    }

    var expirationDate: Date {
        var components = DateComponents()
        components.day = -14
        return Calendar.current.date(byAdding: components, to: Date()) ?? .distantPast
    }

    init() {
        self.refresh()
    }

    subscript(id: String, type: PrismFile.File) -> URL? {
        get {
            guard let object = self.cache.first(where: { $0.id == id }) else { return nil }
            guard let file = object.files.first(where: { $0.file == type }) else { return nil }
            guard let cacheDirectory = self.cacheDirectory else { return nil }
            return cacheDirectory
                .appendingPathComponent(object.id)
                .appendingPathComponent(file.name)
        }
        set(newValue) {
            guard let newValue else { return }
            self.save(with: id, andFile: newValue, forType: type)
        }
    }

    public func refresh() {
        do {
            guard let directory = self.cacheDirectory else { return }
            try self.fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
            self.cache = try self.parseCache(at: directory)
        } catch {
            print("Error loading cache: \(error)")
        }
    }

    func save(with id: String, andFile url: URL, forType type: PrismFile.File) {
        guard let newUrl = self.moveFile(url, in: id, type: type) else { return }
        let file = PrismFile(name: newUrl.lastPathComponent)
        var object = self.cache.first(where: { $0.id == id })
        if object == nil {
            object = PrismObject(id: id, files: [file])
        } else {
            object?.add(file)
        }
        guard let object else { return }
        self.cache.append(object)
        self.refresh()
    }

    func clear() {
        guard let cacheDirectory = self.cacheDirectory else { return }
        try? self.cache.forEach({ try FileManager.default.removeItem(at: cacheDirectory.appendingPathComponent($0.id)) })
    }

    func validateCache() {
        for object in self.cache {
            guard let cacheDirectory = self.cacheDirectory else { continue }
            let objectDirectory = cacheDirectory.appendingPathComponent(object.id)
            guard let contents = try? self.fileManager.contentsOfDirectory(
                at: objectDirectory,
                includingPropertiesForKeys: [.creationDateKey],
                options: .skipsHiddenFiles
            ) else { continue }
            contents.forEach { url in
                do {
                    let resourceValues = try url.resourceValues(forKeys: [.creationDateKey])
                    guard let date = resourceValues.creationDate else { return }
                    guard date < self.expirationDate else { return }
                    try FileManager.default.removeItem(at: url)
                } catch { }
            }
        }
    }

    private func parseCache(at directory: URL) throws -> [PrismObject] {
        let contents = try self.fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        return try contents.map({ folder in
            let contents = try self.fileManager.contentsOfDirectory(at: folder, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
            // For now we are only caring about 2 types, a model and an image,
            // but this can be extended to support more in the future
            return PrismObject(
                id: folder.lastPathComponent,
                files: contents.map({ PrismFile(name: $0.lastPathComponent) })
            )
        })
    }

    private func moveFile(_ url: URL, in id: String, type: PrismFile.File) -> URL? {
        guard let cacheDirectory = self.cacheDirectory else { return nil }
        let directory = cacheDirectory
            .appendingPathComponent(id)
        try? self.fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
        let newPath = directory
            .appendingPathComponent("\(type.rawValue).\(url.pathExtension)")
        try? FileManager.default.moveItem(at: url, to: newPath)
        return newPath
    }
}
// id is the folder name, and files are the files inside
// PrismObject(id: "uuid", files: [PrismFile(name: "model.ply")])
struct PrismObject: Identifiable, Codable {
    let id: String
    var files: [PrismFile]

    mutating func add(_ file: PrismFile) {
        self.files.append(file)
    }

    mutating func remove(_ file: PrismFile) {
        self.files.removeAll(where: { $0.file == file.file })
    }
}

// PrismFile(name: "model.ply") or PrismFile(name: "model.obj")
// [PrismFile(name: "stripes_one.ply"), PrismFile(name: "stripes_two.ply") ...]
// PrismFile(name: "preview.png")
// PrismFile(name: "texture.png")
// PrismFile(name: "avatar.obj.mtl")
struct PrismFile: Identifiable, Codable {
    enum File: String, Codable {
        case preview
        case model
        case stripes
        case texture
        
        // obj file references a avatar.obj.mtl, that name reference is set
        //  in the backend when the obj is created. Because of that the base
        //  name of the mtl must be avatar.obj and as a result the mtl file
        //  full name will be avatar.obj.mtl
        case material = "avatar.obj"

    }

    let file: File
    let name: String

    var id: String { self.name }

    init(name: String) {
        if name.contains("stripes") {
            self.file = .stripes
        } else if name.contains("model") {
            self.file = .model
        } else if name.contains("texture") {
            self.file = .texture
        } else if name.contains("avatar.obj") {
            self.file = .material
        } else {
            self.file = .preview
        }
        self.name = name
    }
}
