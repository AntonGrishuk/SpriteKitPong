//
//  StartScene.swift
//  SpriteKitPong
//
//  Created by Anton Grishuk on 09.11.2023.
//

import Foundation
import SpriteKit

class StartScene: SKScene {
    
    var title: SKLabelNode? {
        childNode(withName: "Title Label") as? SKLabelNode
    }
    
    var startButton: SKShapeNode? {
        childNode(withName: "Start Button") as? SKShapeNode
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        startLabelAnimation()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        for touch in touches {
            let p = touch.location(in: self)
            if atPoint(p) == startButton {
                startButton?.fillColor = .lightGray
                return
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        startButton?.fillColor = .white
        transitToGameScene()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        startButton?.fillColor = .white
    }
    
    private func startLabelAnimation() {
        let zoomIn = SKAction.scale(to: 1 + 0.05, duration: 0.3)
        let nativeZoom = SKAction.scale(to: 1, duration: 0.3)
        let zoomOut = SKAction.scale(to: 1 - 0.05, duration: 0.3)
        let zooming = SKAction.repeatForever(SKAction.sequence([zoomIn, nativeZoom, zoomOut, nativeZoom]))
        
        title?.run(zooming)
    }
    
    private func transitToGameScene() {
        let transition = SKTransition.crossFade(withDuration: 1)
        
        let gameScene = SKScene(fileNamed: "GameScene")
        view?.presentScene(gameScene!, transition: transition)
    }
}
