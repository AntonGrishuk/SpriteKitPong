//
//  GameScene.swift
//  SpriteKitPong
//
//  Created by Anton Grishuk on 15.05.2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var leftPallete: SKSpriteNode?
    private var rightPallete: SKSpriteNode?
    private var ball: SKSpriteNode?
    private var fingerPosition: CGPoint = .zero
    private var isTouching = false {
        didSet {
            if isTouching == false {
                self.leftPallete?.physicsBody?.velocity = CGVector.zero
            } else {
                if(self.fingerPosition.x < 0) {
                    self.leftPallete?.physicsBody?.velocity = CGVector.init(dx: 0, dy: 400)
                } else {
                    self.leftPallete?.physicsBody?.velocity = CGVector.init(dx: 0, dy: -400)
                }
            }
        }
    }
    
    override func didMove(to view: SKView) {
        self.leftPallete = self.childNode(withName: "leftPallete") as? SKSpriteNode
        self.rightPallete = self.childNode(withName: "rightPallete") as? SKSpriteNode
        self.ball = self.childNode(withName: "ball") as? SKSpriteNode
        
        self.leftPallete?.physicsBody?.categoryBitMask = 1
        self.rightPallete?.physicsBody?.categoryBitMask = 1
        self.ball?.physicsBody?.categoryBitMask = 2
        self.ball?.physicsBody?.collisionBitMask = 1
        self.leftPallete?.physicsBody?.contactTestBitMask = 1
        self.leftPallete?.physicsBody?.isDynamic = true
        self.leftPallete?.physicsBody?.usesPreciseCollisionDetection = true
        self.leftPallete?.physicsBody?.mass = 1000000000
        
        self.leftPallete?.physicsBody?.collisionBitMask = 2
        self.rightPallete?.physicsBody?.collisionBitMask = 2
        
        self.ball?.position = CGPoint.zero
        self.ball?.physicsBody?.usesPreciseCollisionDetection = true
        self.ball?.physicsBody?.restitution = 0.0
        self.ball?.physicsBody?.friction = 1.0
        self.leftPallete?.position = CGPoint(x: -250, y: 0)
        self.rightPallete?.position = CGPoint(x: 250, y: 0)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.collisionBitMask = 2
        self.physicsBody?.friction = 0
        self.physicsBody?.restitution = 1.0
        self.physicsBody?.isDynamic = true
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.angularDamping = 0
        self.physicsBody?.categoryBitMask = 1
        self.physicsBody?.contactTestBitMask = 2
        
        self.ball?.physicsBody?.applyImpulse(CGVector(dx: 200, dy: 200))
//        self.ball?.physicsBody?.velocity = CGVector(dx: 100, dy: 100)
        self.physicsWorld.contactDelegate = self
        
        let constraint = SKConstraint.positionY(SKRange.init(lowerLimit: -200, upperLimit: 200))
        let constraintX = SKConstraint.positionX(SKRange.init(lowerLimit: -250, upperLimit: -250))
        self.leftPallete?.constraints = [constraint, constraintX]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        self.fingerPosition = location
        self.isTouching = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        self.fingerPosition = touch.location(in: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.leftPallete?.removeAllActions()
        self.isTouching = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.leftPallete?.removeAllActions()
        self.isTouching = false
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
    }
    
    
    
    override func didEvaluateActions() {
//        print(self.leftPallete?.position)
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {

        if let velocity = self.ball?.physicsBody?.velocity {
            self.ball?.physicsBody?.velocity = CGVector(dx: velocity.dx ,
                                                        dy: velocity.dy )
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
}
