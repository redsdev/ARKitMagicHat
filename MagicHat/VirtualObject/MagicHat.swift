//
//  MagicHat.swift
//  MagicHat
//
//  Created by Lorenzo Rossi on 08/12/17.
//  Copyright © 2017 reds. All rights reserved.
//

import UIKit
import SceneKit

class MagicHat: BaseVirtualObject {
    
    var _innerTube: SCNNode?
    
    init(withPosition position: SCNVector3?) {
        super.init(withPosition: position, sceneResurce: "Model.scnassets/MagicHat", objectName: "Hat")
        
        _innerTube = self.childNode(withName: "tube", recursively: true)        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func containBall(_ ball: MagicBall) -> Bool {
        
        if let boundingBox = _innerTube?.boundingBox {
            let ballPos = ball.getBallWorldCoordinatePos()
            
            let minBB = _innerTube!.convertPosition(boundingBox.min, to: nil)
            let maxBB = _innerTube!.convertPosition(boundingBox.max, to: nil)
            
            return
                ballPos!.x >= minBB.x &&
                    ballPos!.y >= minBB.y &&
                    ballPos!.z >= minBB.z &&
                    ballPos!.x <= maxBB.x &&
                    ballPos!.y <= maxBB.y &&
                    ballPos!.z <= maxBB.z
        }
        else {
            return false
        }
    }
}
