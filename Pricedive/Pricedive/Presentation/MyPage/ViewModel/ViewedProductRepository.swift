//
//  ViewedProductRepository.swift
//  Pricedive
//
//  Created by 신호연 on 2/28/25.
//

import Foundation
import RealmSwift

class ViewedProductRepository {
    private let realm: Realm

    init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("❌ Realm 초기화 실패: \(error.localizedDescription)")
        }
    }

    /// ✅ 최근 본 상품 저장 (중복 제거 후 업데이트)
    func addOrUpdateViewedProduct(_ product: ViewedProduct) {
        let existingProduct = realm.object(ofType: ViewedProductRealm.self, forPrimaryKey: product.id)

        do {
            try realm.write {
                if let existing = existingProduct {
                    // 이미 존재하면 업데이트
                    existing.viewedDate = product.viewedDate
                    existing.videoId = product.videoId
                    print("🔄 최근 본 상품 업데이트: \(existing.title)")
                } else {
                    // 존재하지 않으면 새로 추가
                    let realmObject = product.toRealmObject()
                    realm.add(realmObject, update: .modified)
                    print("✅ 최근 본 상품 추가: \(product.title)")
                }
            }
            removeOldestIfNeeded()
        } catch {
            print("❌ 최근 본 상품 저장 실패: \(error.localizedDescription)")
        }
    }

    /// ✅ 최대 개수 초과 시 가장 오래된 데이터 삭제
    private func removeOldestIfNeeded() {
        let allProducts = realm.objects(ViewedProductRealm.self).sorted(byKeyPath: "viewedDate", ascending: false)
        if allProducts.count > 20 {
            do {
                try realm.write {
                    realm.delete(allProducts.suffix(from: 20))
                }
                print("✅ 초과된 \(allProducts.count - 20)개 최근 본 상품 삭제 완료")
            } catch {
                print("❌ 초과된 최근 본 상품 삭제 실패: \(error.localizedDescription)")
            }
        }
    }

    /// ✅ 저장된 최근 본 상품 불러오기 (최신순 정렬)
    func getViewedProducts() -> [ViewedProduct] {
        return realm.objects(ViewedProductRealm.self)
            .sorted(byKeyPath: "viewedDate", ascending: false)
            .prefix(20)
            .map { ViewedProduct(from: $0) }
    }

    /// ✅ 모든 최근 본 상품 삭제
    func clearAllViewedProducts() {
        do {
            try realm.write {
                realm.delete(realm.objects(ViewedProductRealm.self))
            }
            print("✅ 모든 최근 본 상품 삭제 완료")
        } catch {
            print("❌ 최근 본 상품 삭제 실패: \(error.localizedDescription)")
        }
    }
}
