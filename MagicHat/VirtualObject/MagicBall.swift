//
//  MagicBall.swift
//  MagicHat
//
//  Created by Lorenzo Rossi on 08/12/17.
//  Copyright © 2017 reds. All rights reserved.
//

import UIKit
import SceneKit

class MagicBall: BaseVirtualObject {
    
    var _ball : SCNNode?
    
    init(withPosition position: SCNVector3?) {
        super.init(withPosition: position, sceneResurce: "Model.scnassets/Ball", objectName: "Sphere")
        
        _ball = self.childNode(withName: "Sphere", recursively: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func throwBall()
    {
        let force : Float = 2.0
        _ball?.physicsBody?.applyForce( SCNVector3(self.worldFront.x * force, self.worldFront.y * force, self.worldFront.z * force), asImpulse: true)
    }
    
    public func hideShowAnimation(hideBall hide: Bool, removeBall remove: Bool)
    {
        if !hide {
            _ball?.isHidden = false
        }
        
        SCNTransaction.begin()
        _ball?.opacity = hide ? 0 : 1
        SCNTransaction.animationDuration = 2
        SCNTransaction.completionBlock = {
            if hide {
                self._ball?.isHidden = true
            }
            if remove {
                self.removeFromParentNode()
                
            }
        }
        SCNTransaction.commit()
    }
    
    public func getBallWorldCoordinatePos() -> SCNVector3?
    {
        if _ball != nil {
            return _ball!.presentation.worldPosition
        }
        else {
            return nil
        }
    }
}
