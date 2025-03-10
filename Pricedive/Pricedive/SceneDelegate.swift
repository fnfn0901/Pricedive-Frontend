//
//  SceneDelegate.swift
//  Pricedive
//
//  Created by 신호연 on 11/20/24.
//

import UIKit
import RealmSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        configureRealmMigration()
        
        let splashViewModel = SplashViewModel()
        let splashViewController = SplashViewController(viewModel: splashViewModel)

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = splashViewController
        window?.makeKeyAndVisible()
    }

    /// ✅ Realm 마이그레이션 설정
    private func configureRealmMigration() {
        let config = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                    migration.enumerateObjects(ofType: ViewedProductRealm.className()) { _, newObject in
                        newObject?["eventEndDate"] = ""
                    }
                }
            }
        )

        Realm.Configuration.defaultConfiguration = config

        do {
            _ = try Realm()
        } catch {
            fatalError("❌ Realm 초기화 실패: \(error.localizedDescription)")
        }
    }
}
