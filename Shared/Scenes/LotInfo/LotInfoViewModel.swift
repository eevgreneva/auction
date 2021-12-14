//
//  LotInfoViewModel.swift
//  auction
//
//  Created by Евгения Ренева on 03.12.2021.
//

import Foundation
import SwiftUI
import FirebaseStorage

final class LotInfoViewModel: BaseViewModel {

    @Published var lotImage: UIImage?

    var isAuctioneer: Bool {
        firebaseManager.user.isAuctioneer
    }

    var balance: Int {
        firebaseManager.user.userData?.balance ?? 0
    }

    func loadImage(with name: String) {
        firebaseManager.loadLotImage(with: name) { [weak self] image in
            self?.lotImage = image
        }
    }

    func acceptBid(lot: Lot, completion: @escaping (Lot) -> Void) {
        firebaseManager.acceptBid(for: lot) { lot, isSuccess in
            if isSuccess {

            }

            completion(lot)
        }
    }

    func makeBid(lot: Lot, bid: Int, completion: @escaping (Lot) -> Void) {
        firebaseManager.makeBid(for: lot, bid: bid, completion: completion)
    }
}
