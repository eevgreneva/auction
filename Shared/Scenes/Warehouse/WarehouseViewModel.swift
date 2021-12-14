//
//  WarehouseViewModel.swift
//  auction
//
//  Created by Евгения Ренева on 04.12.2021.
//

import Foundation
import Firebase
import SwiftUI

final class WarehouseViewModel: BaseViewModel {

    @Published var lots: [Lot] = []

    var isAuctioneer: Bool {
        firebaseManager.user.isAuctioneer
    }

    func fetchData() {
        firebaseManager.addWarehouseChangeListener { [weak self] lots in
            guard let lots = lots else { return }
            self?.lots = lots
        }
    }
}
