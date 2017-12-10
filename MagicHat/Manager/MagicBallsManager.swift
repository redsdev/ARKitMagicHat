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
    var ballHidden = false
    
    public func createAndThrowBall(sceneView scene:ARSCNView, transformCamera transform: matrix_float4x4) {
        let mat = SCNMatrix4(transform)
        let pos = SCNVector3(mat.m41, mat.m42, mat.m43)
        
        let ball = MagicBall(withPosition: pos)
        arrayBalls.append(ball)
        scene.scene.rootNode.addChildNode(ball)

        ball.simdTransform = transform
        
        ball.throwBall()
    }
    
    public func hideShowBallsInsideHat(magicHat hat: MagicHat?, removeAfterHide remove: Bool) -> Bool
    {
        if hat == nil {
            return false
        }
        
        ballHidden = !ballHidden
        
        var ballsInsideHatArray = [Int]()
        arrayBalls.forEach { (ball) in
            if hat!.containBall(ball) {
                ball.hideShowAnimation(hideBall: ballHidden, removeBall: remove)
                ballsInsideHatArray.append(arrayBalls.index(of: ball)!)
            }
        }

        if remove {
            ballsInsideHatArray.sort(by: { (a, b) -> Bool in
                return a>b
            })
            
            ballsInsideHatArray.forEach { (idx) in
                arrayBalls.remove(at: idx)
            }
        }
        
        return ballsInsideHatArray.count > 0
    }
}
