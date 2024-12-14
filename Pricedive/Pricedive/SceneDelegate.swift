//
//  SceneDelegate.swift
//  Pricedive
//
//  Created by 신호연 on 11/20/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let mainTabBarController = MainTabBarController()
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = mainTabBarController
        window?.makeKeyAndVisible()
    }
}
