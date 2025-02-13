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

        let splashViewModel = SplashViewModel()
        let splashViewController = EventDetailViewController(eventId: 1, homeViewModel: HomeViewModel())

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = splashViewController
        window?.makeKeyAndVisible()
    }
}
