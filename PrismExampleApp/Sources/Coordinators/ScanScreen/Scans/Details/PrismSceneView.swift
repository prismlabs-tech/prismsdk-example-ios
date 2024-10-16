/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SceneKit
import SwiftUI

struct Camera {
    static let `default` = Camera(
        position: SCNVector3(x: 0, y: 0, z: 1.0),
        rotation: SCNVector4(0, 0, 0, 0),
        orientation: SCNVector4(x: 0, y: 0, z: 0, w: 1.0),
        fieldOfView: CGFloat(60)
    )

    let position: SCNVector3
    let rotation: SCNVector4
    let orientation: SCNVector4
    let fieldOfView: CGFloat

    init(position: SCNVector3, rotation: SCNVector4, orientation: SCNVector4, fieldOfView: CGFloat) {
        self.position = position
        self.rotation = rotation
        self.orientation = orientation
        self.fieldOfView = fieldOfView
    }

    init(from node: SCNNode) {
        self.init(position: node.position, rotation: node.rotation, orientation: node.orientation, fieldOfView: Camera.default.fieldOfView)
    }
}

struct PrismSceneView: UIViewRepresentable {
    typealias Context = UIViewRepresentableContext<Self>
    typealias UIViewType = SCNView

    let model: SCNScene?
    let stripes: SCNScene?
    let stripeColor: Color

    @Binding var camera: Camera?

    func makeUIView(context: Context) -> SCNView {
        context.coordinator.view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        context.coordinator.set(camera: self.camera)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, SCNSceneRendererDelegate {
        private let parent: PrismSceneView
        private let camera = SCNCamera()
        private let cameraNode = SCNNode()
        private let scene = SCNScene()

        let view = SCNView()

        init(_ parent: PrismSceneView) {
            self.parent = parent
            super.init()

            self.view.backgroundColor = .clear
            self.view.delegate = self
            self.view.pointOfView = self.cameraNode
            self.view.allowsCameraControl = true
            self.view.autoenablesDefaultLighting = true
            self.view.scene = self.scene
            
            // Fix model plane clipping
            self.camera.zNear = 0.1
            self.camera.zFar = 1000

            self.camera.name = "Camera"
            self.cameraNode.camera = self.camera
            self.cameraNode.name = "CameraNode"
            self.cameraNode.position = parent.camera?.position ?? Camera.default.position
            self.scene.rootNode.addChildNode(self.cameraNode)

            guard let scene = parent.model else { return }
            self.addNodes(from: scene, and: parent.stripes)
        }

        /// Adds all of the nodes to the scene
        private func addNodes(from scene: SCNScene, and stripes: SCNScene?) {
            scene.rootNode.childNodes.forEach { node in
                node.name = "Model"
                self.setDefaultPosition(for: node)
                self.scene.rootNode.addChildNode(node)
            }

            let model = self.scene.rootNode.childNodes.first(where: { $0.name == "Model" })
            stripes?.rootNode.childNodes.forEach { node in
                node.name = "Stripes"
                node.geometry?.materials = [self.createMaterial(with: UIColor(self.parent.stripeColor))]
                model?.addChildNode(node)
            }
        }

        /// Creates the material color needed to highlight the rings.
        func createMaterial(with color: UIColor) -> SCNMaterial {
            let material = SCNMaterial()
            material.locksAmbientWithDiffuse = true
            material.isDoubleSided = false
            material.lightingModel = .physicallyBased
            material.diffuse.contents = color
            material.specular.contents = color
            material.emission.contents = color
            material.transparent.contents = color
            material.reflective.contents = color
            material.normal.contents = color
            material.ambientOcclusion.contents = color
            material.metalness.contents = color
            material.roughness.contents = color
            material.displacement.contents = color
            return material
        }

        // this calculates where the model should be placed based on the radius of the bounding sphere
        // and its relationship to the y and z coordinates I calculated from a handful of models
        // these came about from a lot of back of the envelope math, so don't take them as hard truth
        // however, if we need to adjust coordinates, this is the place to do it
        private func setDefaultPosition(for node: SCNNode) {
            let (_, radius) = node.boundingSphere
            let y = (-0.9665 * radius)
            let z = (-2.274 * radius) + 1.218

            node.scale = SCNVector3(x: 1.0, y: 1.0, z: 1.0)
            node.position = SCNVector3(x: 0, y: y, z: z)
            node.rotation = SCNVector4(x: 0, y: 0, z: 1, w: .pi / 2)
        }

        func set(camera: Camera?) {
            guard let camera else { return }
            // I HATE leaving commented code lying around but since we are still trying to figure out all this animation stuff
            // I wanted to leave a direct reminder of what was (mostly) working before so that there's an easy reference
            // We can remove it once a better solution is in place
//            SCNTransaction.begin()
//            SCNTransaction.animationDuration = 1
//            self.view.pointOfView?.position = camera.position
//            self.view.pointOfView?.rotation = camera.rotation
//            self.view.pointOfView?.orientation = camera.orientation
//            self.view.pointOfView?.camera?.fieldOfView = camera.fieldOfView
//            SCNTransaction.commit()
            let action = SCNAction.customAction(duration: 1, action: { _, _ in
                self.view.pointOfView?.position = camera.position
                self.view.pointOfView?.rotation = camera.rotation
                self.view.pointOfView?.orientation = camera.orientation
                self.view.pointOfView?.camera?.fieldOfView = camera.fieldOfView
            })
            self.view.scene?.rootNode.runAction(action)
        }

        func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
            self.parent.camera = nil
        }

        func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {}

        func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {}
    }
}
