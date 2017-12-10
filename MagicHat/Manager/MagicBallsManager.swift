//
//  MagicBallsManager.swift
//  MagicHat
//
//  Created by Lorenzo Rossi on 08/12/17.
//  Copyright © 2017 reds. All rights reserved.
//

import UIKit
import ARKit

class MagicBallsManager: NSObject {
    
    var arrayBalls = [MagicBall]()
    
    public func createAndThrowBall(sceneView scene:ARSCNView, transformCamera transform: matrix_float4x4) {
        let mat = SCNMatrix4(transform)
        let pos = SCNVector3(mat.m41, mat.m42, mat.m43)
        
        let ball = MagicBall(withPosition: pos)
        arrayBalls.append(ball)
        scene.scene.rootNode.addChildNode(ball)

        ball.simdTransform = transform
        
        ball.throwBall()
    }
    
    public func hideBallsInsideHat(magicHat hat: MagicHat?) -> Bool
    {
        if hat == nil {
            return false
        }
        
        var removeArray = [Int]()
        arrayBalls.forEach { (ball) in
            if hat!.containBall(ball) {
                ball.hideAndRemoveAnimation()
                removeArray.append(arrayBalls.index(of: ball)!)
            }
        }

        removeArray.sort(by: { (a, b) -> Bool in
            return a>b
        })
        
        removeArray.forEach { (idx) in
            arrayBalls.remove(at: idx)
        }
        
        return removeArray.count > 0
    }
}
