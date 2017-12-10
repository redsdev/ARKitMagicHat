//
//  ViewController.swift
//  MagicHat
//
//  Created by Lorenzo Rossi on 04/12/17.
//  Copyright © 2017 reds. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet var buttonMagic: UIButton!
    @IBOutlet var buttonThrow: UIButton!
    
    @IBOutlet var viewMessage: UIView!
    @IBOutlet var labelMessage: UILabel!

    let omniLight = SCNLight()
    let ambientLight = SCNLight()
    let ballsManager = MagicBallsManager()
    var timerMessage: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.styleMessageView()
        self.styleButton(buttonMagic)
        self.styleButton(buttonThrow)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        // Set the scene to the view
        sceneView.scene = SCNScene()
        createAndSetupSceneLight()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showMessage("Find a good plane surface")
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func styleMessageView()
    {
        self.viewMessage.layer.cornerRadius = 10
    }
    
    func styleButton(_ button: UIButton) {
        button.layer.cornerRadius = 40
        
        button.layer.borderWidth = 2
        button.layer.borderColor = button.titleColor(for: .normal)?.cgColor
    }
    
    func createAndSetupSceneLight()
    {
        sceneView.autoenablesDefaultLighting = false
        sceneView.automaticallyUpdatesLighting = false
        sceneView.antialiasingMode = .multisampling4X
        
        omniLight.type = .omni
        omniLight.color = UIColor.white
        let omniLightNode = SCNNode()
        omniLightNode.light = omniLight
        omniLightNode.position = SCNVector3(x: -30, y: 30, z: 60)
        
        ambientLight.type = .ambient
        ambientLight.intensity = 40
        let nodeAmbinetLight = SCNNode()
        nodeAmbinetLight.light = ambientLight
        
        sceneView.scene.rootNode.addChildNode(omniLightNode)
        sceneView.scene.rootNode.addChildNode(nodeAmbinetLight)
    }

    // MARK: - ARSCNViewDelegate    
    private var magicHat: MagicHat?

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if magicHat != nil {
            return
        }
        
        // Create an SNCPlane on the ARPlane
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        
        magicHat = MagicHat(withPosition: SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z))
        node.addChildNode(magicHat!)

        showMessage("Magic Hat created!!")
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if let lightEstimate = sceneView.session.currentFrame?.lightEstimate {
            omniLight.intensity = lightEstimate.ambientIntensity
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        showMessage("AR Session Error")
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        showMessage("AR Session interrupted")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    @IBAction func throwBallTap(_ sender: Any) {
        if magicHat == nil {
            return
        }
        
        let camera = sceneView.session.currentFrame?.camera
        if let cameraTransform = camera?.transform {
            ballsManager.createAndThrowBall(sceneView: self.sceneView, transformCamera: cameraTransform)
        }
    }
    
    @IBAction func magicTap(_ sender: Any) {
        if ballsManager.hideBallsInsideHat(magicHat: magicHat) {
            showMessage("Magic!")
        }
    }
}
