//
//  StartViewController.swift
//  SpriteKitPong
//
//  Created by Anton Grishuk on 29.10.2023.
//

import UIKit
import SpriteKit

class MainViewController: UIViewController {
    
    private let spriteKitView: SKView = {
        let view = SKView()
        #if DEBUG
        view.showsFPS = true
        #endif
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadStartScene()        
    }
    
    private func configureUI() {
        view.backgroundColor = .red
        view.addSubview(spriteKitView)
        
        NSLayoutConstraint.activate([
            spriteKitView.topAnchor.constraint(equalTo: view.topAnchor),
            spriteKitView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            spriteKitView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            spriteKitView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func loadStartScene() {
        spriteKitView.presentScene(.init(fileNamed: "StartScene"))
    }

}
