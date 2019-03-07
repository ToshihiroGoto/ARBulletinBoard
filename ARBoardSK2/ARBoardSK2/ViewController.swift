//
//  ViewController.swift
//  ARBoardSK2
//
//  Created by Toshihiro Goto on 2019/03/07.
//  Copyright © 2019 Toshihiro Goto. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, UITextFieldDelegate {

    private var skScene: SKScene!
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "main.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // ----------------------------------------
        // Sprite Kit
        // ----------------------------------------
        
        let boardSK = scene.rootNode.childNode(withName: "BoardSK", recursively: true)!
        
        // SpriteKit Scene
        skScene = SKScene(size: CGSize.init(width: 5000, height: 256))
        skScene.anchorPoint = CGPoint(x:0.5, y: 0.5)
        skScene.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7)
        
        // Camera
        let cameraNode = SKCameraNode()
        
        cameraNode.position = CGPoint(x: 0, y: 0)
        cameraNode.yScale = -1
        
        skScene.addChild(cameraNode)
        skScene.camera = cameraNode
        
        // Set Defuse Material
        boardSK.geometry?.firstMaterial?.diffuse.contents = skScene
        
        
        // ----------------------------------------
        // Text Field
        // ----------------------------------------
        
        textField.delegate = self
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
    }
    
    
    // Action
    
    // Tap Scene
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        inputText()
    }
    
    // Tap Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        inputText()
        
        return true
    }
    
    func inputText(){
        textField.resignFirstResponder()
        
        var text = textField.text!
        
        if text == "" || text.isEmpty {
            text = "🍣 🍣 🍣 🍣 🍣 🍣 🍣 🍣 🍣 🍣 🍣 🍣"
            textField.text = text
        }
        
        
        setScrollText(text)
    }
    
    func setScrollText(_ text:String){
        
        // Font Settings
        let systemFont = UIFont.systemFont(ofSize: 140, weight: UIFont.Weight.bold)
        let fontSize:CGFloat = 140
        let labelPosY = -CGFloat(fontSize / 3)
        
        // Text Label
        let labelNode = SKLabelNode()
        labelNode.fontName = systemFont.fontName
        labelNode.text = text
        labelNode.fontSize = fontSize
        labelNode.horizontalAlignmentMode = .left
        labelNode.fontColor = SKColor.green
        labelNode.position = CGPoint(x: skScene.size.width / 2, y: labelPosY)
        
        skScene.addChild(labelNode)
        
        // Animation Settings
        let totalTextSize = labelNode.frame.width + skScene.size.width
        
        let duration = (totalTextSize / labelNode.frame.height) * 0.2
        let endPos   = CGPoint(x:-totalTextSize, y:labelPosY)
        
        // SKAction
        let move = SKAction.move(to: endPos, duration: TimeInterval(duration))
        labelNode.run(move, completion: {() -> Void in
            labelNode.removeFromParent()
        })
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
