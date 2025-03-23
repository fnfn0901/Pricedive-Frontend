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
        let existingProduct = realm.object(ofType: ViewedProductRealm.self, forPrimaryKey: product.videoId)

        do {
            try realm.write {
                if let existing = existingProduct {
                    existing.viewedDate = product.viewedDate
                    existing.eventEndDate = product.eventEndDate
                    existing.title = product.title
                    existing.imageUrl = product.imageUrl
                    existing.id = product.id
                } else {
                    let realmObject = product.toRealmObject()
                    realm.add(realmObject, update: .modified)
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
    
    func deleteViewedProduct(_ product: ViewedProduct) {
        guard let productToDelete = realm.object(ofType: ViewedProductRealm.self, forPrimaryKey: product.videoId) else {
            print("❌ 삭제할 상품을 찾을 수 없음: \(product.title)")
            return
        }

        do {
            try realm.write {
                realm.delete(productToDelete)
            }
            print("✅ 최근 본 상품 삭제 완료: \(product.title)")
        } catch {
            print("❌ 최근 본 상품 삭제 실패: \(error.localizedDescription)")
        }
    }
}
