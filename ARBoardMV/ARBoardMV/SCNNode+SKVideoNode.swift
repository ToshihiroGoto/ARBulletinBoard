//
//  SCNNode+SKVideoNode.swift
//  ARBoardMV
//
//  Created by Toshihiro Goto on 2019/02/28.
//  Copyright © 2017年 Toshihiro Goto. All rights reserved.
//

import UIKit
import SceneKit
import SpriteKit
import AVFoundation

extension SCNNode {
    
    func setVideo(movieFileName: String, width _width: Float, height _height: Float){
        
        // Split FileName
        let split = movieFileName.components(separatedBy: ".")
        
        // Set AVPlayer
        let item = AVPlayerItem(url: URL(fileURLWithPath: Bundle.main.path(forResource: split[0], ofType: split[1])!))
        let videoPlayer = AVPlayer(playerItem: item)
        
        videoPlayer.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none;
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.stateVideoNodeEnd),
                                               name: NSNotification.Name("AVPlayerItemDidPlayToEndTimeNotification"),
                                               object: videoPlayer.currentItem)
        videoPlayer.play()
        
        // SKScene
        let skScene = SKScene()
        let videoSize = CGSize(width: CGFloat(_width), height: CGFloat(_height))
        skScene.backgroundColor = UIColor.black
        skScene.size = videoSize

        // Anchor Point
        let centerPoint = CGPoint(x: CGFloat(_width/2), y: CGFloat(_height/2))

        // Video Node
        let skVideoNode = SKVideoNode(avPlayer: videoPlayer)
        skVideoNode.size = videoSize
        skVideoNode.position = centerPoint
        skScene.addChild(skVideoNode)

        // Camera Node (-Y)
        let cameraNode = SKCameraNode()
        cameraNode.position = centerPoint
        cameraNode.yScale = -1
        skScene.addChild(cameraNode)
        
        // Set Camera
        skScene.camera = cameraNode
        
        // Set SKScene > SCNNode Diffuse
        self.geometry?.firstMaterial?.diffuse.contents = skScene
    }
    
    // Video Loop
    @objc
    func stateVideoNodeEnd(notification: NSNotification) {
        let avPlayerItem = notification.object as? AVPlayerItem
        avPlayerItem?.seek(to: CMTime.zero, completionHandler: nil)
    }

}
