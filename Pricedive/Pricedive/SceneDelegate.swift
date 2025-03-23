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
            schemaVersion: 3,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 3 {
                    migration.enumerateObjects(ofType: ViewedProductRealm.className()) { oldObject, newObject in
                        newObject?["videoId"] = oldObject?["videoId"] as? Int ?? -1
                    }
                }
            }
        )
        Realm.Configuration.defaultConfiguration = config

        do {
            _ = try Realm()
            print("✅ Realm 초기화 성공")
        } catch {
            fatalError("❌ Realm 초기화 실패: \(error.localizedDescription)")
        }
    }
    
    private func resetRealmDataIfNeeded() {
        let config = Realm.Configuration.defaultConfiguration
        if let url = config.fileURL {
            do {
                try FileManager.default.removeItem(at: url)
                print("✅ 기존 Realm DB 삭제 완료")
            } catch {
                print("❌ 기존 Realm DB 삭제 실패: \(error.localizedDescription)")
            }
        }
    }
}
