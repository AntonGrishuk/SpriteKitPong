//
//  GameScene.swift
//  SpriteKitPong
//
//  Created by Anton Grishuk on 15.05.2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
        
    private struct GameMask: OptionSet {
        var rawValue: UInt32
        
        static let field    = GameMask(rawValue: 1 << 0)
        static let paddle  = GameMask(rawValue: 1 << 1)
        static let ball     = GameMask(rawValue: 1 << 2)
    }
    
    private var gameFieldSize: CGSize {
        .init(width: frame.height * 1.5, height: frame.height - 50)
    }
    
    private lazy var gameField: SKShapeNode = .init( rectOf: gameFieldSize )
    
    private var leftPallete: SKSpriteNode = .init(imageNamed: "left_pallete")
    private var rightPallete: SKSpriteNode = .init(imageNamed: "right_pallete")
    private var ball = SKShapeNode(circleOfRadius: 15)
    private var leftScoreNode = SKLabelNode(text: "0")
    private var rightScoreNode = SKLabelNode(text: "0")
    private var score: (Int, Int) = (0, 0) {
        didSet {
            updateScore()
        }
    }
    
    // MARK: - SKScene methods
        
    override func didMove(to view: SKView) {
        configureGameField()
        configureLeftPaddle()
        configureRightPaddle()
        configureBall()
        
        physicsWorld.contactDelegate = self
        
        startGame()
    }
    
    override func update(_ currentTime: TimeInterval) {
        let moveAction = SKAction.moveTo(y: ball.position.y, duration: 0.05)
        
        // Autoplay
        
        if ball.position.x > 20 && ball.physicsBody!.velocity.dx > 0 {
            rightPallete.run(moveAction)
        }
        
        if ball.position.x < -20 && ball.physicsBody!.velocity.dx < 0  {
            leftPallete.run(moveAction)
        }
    }
    
    // MARK: - Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let moveAction = SKAction.moveTo(y: location.y, duration: 0)
        if location.x < 0 {
            leftPallete.run(moveAction)
        } else {
            rightPallete.run(moveAction)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let moveAction = SKAction.moveTo(y: location.y, duration: 0)
        if location.x < 0 {
            leftPallete.run(moveAction)
        } else {
            rightPallete.run(moveAction)
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        leftPallete.removeAllActions()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.leftPallete.removeAllActions()
    }
    
    // MARK: - Private
    
    private func countdown(text: String, completion: @escaping () -> ()) {
        let textNode = SKLabelNode(text: text)
        textNode.fontColor = .white
        textNode.fontSize = 100
        textNode.fontName = UIFont.monospacedSystemFont(ofSize: 100, weight: .bold).fontName
        textNode.position = .init(x: frame.midX, y: frame.midY)
        addChild(textNode)
        
        let fade = SKAction.fadeOut(withDuration: 1)
        let resize = SKAction.scale(to: 5, duration: 1)
        let move = SKAction.moveTo(y: position.y - 150, duration: 1)
        let group = SKAction.group([resize, fade, move])
        
        textNode.run(group) {
            textNode.removeFromParent()
            completion()
        }
    }
    
    private func startGame() {
        let moveAction = SKAction.move(to: .zero, duration: 0)
        ball.run(moveAction)

        countdown(text: "3") { [weak self] in
            self?.countdown(text: "2", completion: { [weak self] in
                self?.countdown(text: "1", completion: { [weak self] in
                    self?.countdown(text: "Go!", completion: { [weak self] in
                        let randomDirectionX: CGFloat = Bool.random() ? 1 : -1
                        let randomDirectionY: CGFloat = Bool.random() ? 1 : -1
                        self?.ball.physicsBody?.velocity =
                            CGVector(dx: randomDirectionX * 300,
                                     dy: randomDirectionY * 300)
                    })
                })
            })
        }
    }
    
    private func configureGameField() {
        gameField.physicsBody = SKPhysicsBody.init(edgeLoopFrom: gameField.path!)
        
        gameField.physicsBody?.categoryBitMask = GameMask.field.rawValue
        gameField.physicsBody?.contactTestBitMask = GameMask.ball.rawValue
        
        gameField.physicsBody?.friction = 0
        gameField.physicsBody?.restitution = 1
        gameField.physicsBody?.isDynamic = false
        gameField.physicsBody?.affectedByGravity = false
        gameField.physicsBody?.linearDamping = 0
        gameField.physicsBody?.angularDamping = 0
        
        gameField.lineWidth = 3
        addChild(gameField)
        
        addCentralLine()
        configureScoreNodes()
    }
    
    private func addCentralLine() {
        let path = UIBezierPath()
        path.move(to: .init(x: 0, y: -gameField.frame.height / 2 + 3))
        path.addLine(to: .init(x: 0, y: gameField.frame.height / 2 - 3))
        let cgPath = path.cgPath.copy(dashingWithPhase: 0.0, lengths: [5, 2])
        let centralLine = SKShapeNode(path: cgPath)
        centralLine.strokeColor = .white
        centralLine.lineWidth = 2
        
        gameField.addChild(centralLine)
    }
    
    private func configureScoreNodes() {
        leftScoreNode.fontSize = 100
        leftScoreNode.fontName = UIFont.monospacedSystemFont(ofSize: 100, weight: .ultraLight).fontName
        leftScoreNode.position = .init(x: -gameField.frame.width / 4, y: gameField.frame.midY - 30)
        leftScoreNode.fontColor = .init(red: 0.5, green: 0.5, blue: 1, alpha: 0.4)
        gameField.addChild(leftScoreNode)
        
        rightScoreNode.fontSize = 100
        rightScoreNode.fontName = UIFont.monospacedSystemFont(ofSize: 100, weight: .ultraLight).fontName
        rightScoreNode.position = .init(x: gameField.frame.width / 4, y: gameField.frame.midY - 30)
        rightScoreNode.fontColor = .init(red: 1, green: 0.5, blue: 0.5, alpha: 0.2)
        gameField.addChild(rightScoreNode)
    }
    
    private func configureBall() {    
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 15)

        ball.physicsBody?.categoryBitMask = GameMask.ball.rawValue
        ball.physicsBody?.collisionBitMask = GameMask.field.rawValue | GameMask.paddle.rawValue
        
        ball.position = CGPoint.zero
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.usesPreciseCollisionDetection = true
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.mass = 0.3
        ball.physicsBody?.friction = 0.0
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.angularDamping = 0
        ball.fillColor = .systemOrange
        ball.strokeColor = .white
        ball.lineWidth = 3
        
        addChild(ball)
    }
    
    private func configureLeftPaddle() {
        leftPallete.physicsBody = SKPhysicsBody(
        texture: .init(image: .init(imageLiteralResourceName: "left_pallete")),
        size: .init(width: 5, height: 50))
        
        leftPallete.physicsBody?.categoryBitMask = GameMask.paddle.rawValue
        leftPallete.physicsBody?.contactTestBitMask = GameMask.ball.rawValue

        
        leftPallete.size = .init(width: 5, height: 50)
        leftPallete.physicsBody?.isDynamic = false
        leftPallete.physicsBody?.usesPreciseCollisionDetection = true
        leftPallete.physicsBody?.friction = 0
        leftPallete.physicsBody?.restitution = 1
        leftPallete.position = CGPoint(x: gameField.frame.minX + 20, y: 0)

        let yConstraint = (gameField.frame.height - 50) / 2 - 5
        
        let range = SKRange(
            lowerLimit: -yConstraint,
            upperLimit: yConstraint)
        let topConstraint = SKConstraint.positionY(range)
        leftPallete.constraints = [topConstraint]
        
        addChild(leftPallete)
    }
    
    private func configureRightPaddle() {
        rightPallete.physicsBody = SKPhysicsBody(
        texture: .init(image: .init(imageLiteralResourceName: "right_pallete")),
        size: .init(width: 5, height: 50))
        
        rightPallete.physicsBody?.categoryBitMask = GameMask.paddle.rawValue
        rightPallete.physicsBody?.contactTestBitMask = GameMask.ball.rawValue
        
        rightPallete.size = .init(width: 5, height: 50)
        rightPallete.physicsBody?.isDynamic = false
        rightPallete.physicsBody?.usesPreciseCollisionDetection = true
        rightPallete.physicsBody?.friction = 0
        rightPallete.physicsBody?.restitution = 1
        rightPallete.position = CGPoint(x: gameField.frame.maxX - 20, y: 0)
        
        let yConstraint = (gameField.frame.height - 50) / 2 - 5
        
        let range = SKRange(
            lowerLimit: -yConstraint,
            upperLimit: yConstraint)
        let topConstraint = SKConstraint.positionY(range)
        rightPallete.constraints = [topConstraint]
        
        addChild(rightPallete)
    }
    
    private func updateScore() {
        leftScoreNode.text = "\(score.0)"
        rightScoreNode.text = "\(score.1)"
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        
        switch contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask {
        case GameMask.ball.rawValue | GameMask.field.rawValue where
            contact.contactPoint.x < leftPallete.position.x:
            score.1 += 1
            ball.physicsBody?.velocity = .zero
            startGame()
            return
            
        case GameMask.ball.rawValue | GameMask.field.rawValue where
            contact.contactPoint.x > rightPallete.position.x:
            score.0 += 1
            ball.physicsBody?.velocity = .zero
            startGame()
            return
            
        case GameMask.ball.rawValue | GameMask.paddle.rawValue:
            let increase = SKAction.resize(toWidth: 10, duration: 0.1)
            let decrease = SKAction.resize(toWidth: 5, duration: 0.1)
            
            if contact.bodyA.categoryBitMask == GameMask.paddle.rawValue {
                contact.bodyA.node?.run(.sequence([increase, decrease]))
            } else {
                contact.bodyB.node?.run(.sequence([increase, decrease]))
            }
            
        default:
            break
        }
        
            // prevent infinite reflection of the ball
        
        if abs(ball.physicsBody?.velocity.dx ?? 0) < 0.1 {
            let random: CGFloat = Bool.random() ? 1 : -1
            ball.physicsBody?.applyImpulse(.init(dx: random * 20, dy: 0))
        }

        if abs(ball.physicsBody?.velocity.dy ?? 0) < 0.1 {
            let random: CGFloat = Bool.random() ? 1 : -1
            ball.physicsBody?.applyImpulse(.init(dx: 0, dy: random * 20))
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
}
