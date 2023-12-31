//
//  GameViewController.swift
//  SpriteKitPong
//
//  Created by Anton Grishuk on 15.05.2021.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var gameScene: SKScene?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let view = self.view as? SKView,
              let scene = SKScene(fileNamed: "GameScene") else {
            return
        }

        scene.scaleMode = .aspectFit
        
        view.presentScene(scene)
        self.gameScene = scene
        
        
        view.ignoresSiblingOrder = true
        
        view.showsFPS = true
        view.showsNodeCount = true
        view.showsPhysics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
