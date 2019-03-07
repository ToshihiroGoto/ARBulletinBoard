//
//  SCNAction+moveDiffuseU.swift
//  ARBoardUV
//
//  Created by Toshihiro Goto on 2019/02/28.
//  Copyright © 2019 Toshihiro Goto. All rights reserved.
//

import SceneKit

extension SCNAction {
    
    /**
        Move the U coordinate of the Diffuse texture by the time of the parameter duration.
     
        - note: Movement direction is 0 to 1.
    */
    /// - parameter duration: Movement time between 0 to 1 of Diffuse U coordinates. default is 1.0. (TimeInterval Type)
    /// - returns: A new action object.
    open class func moveDiffuseU(_ duration:TimeInterval = 1) -> SCNAction{
        
        var uvPostion = float4x4.init(1)
        
        return SCNAction.customAction(duration: duration, action: { (node, elapsedTime) in
            
            uvPostion[3].x = Float(elapsedTime) / Float(duration)
            
            node.geometry?.firstMaterial?.diffuse.contentsTransform = SCNMatrix4(uvPostion)
            
            // print("elapsedTime \(elapsedTime)")
            // print("uvPostion[3].x \(uvPostion[3].x)")
            
        })
    }
}
