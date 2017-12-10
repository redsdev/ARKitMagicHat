//
//  BaseVirtualObject.swift
//  MagicHat
//
//  Created by Lorenzo Rossi on 08/12/17.
//  Copyright © 2017 reds. All rights reserved.
//

import UIKit
import SceneKit

class BaseVirtualObject: SCNNode {
    init(withPosition position: SCNVector3?, sceneResurce scene: String, objectName objName: String) {
        super.init()
        
        guard let url = Bundle.main.url(forResource: scene, withExtension: "scn") else {
            NSLog("Could not find scene")
            return
        }
        
        guard let sceneNode = SCNReferenceNode(url: url) else { return }
        sceneNode.load()
        if let objNode = sceneNode.childNode(withName: objName, recursively: true) {
            self.addChildNode(objNode)
        }
        
        if position != nil {
            self.position = position!
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
