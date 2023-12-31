//
//  SceneDelegate.swift
//  SpriteKitPong
//
//  Created by Anton Grishuk on 29.10.2023.
//

import UIKit

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions)
    {
        window = UIWindow(windowScene: scene as! UIWindowScene)
        window?.makeKeyAndVisible()
        window?.rootViewController = MainViewController()
    }
}
