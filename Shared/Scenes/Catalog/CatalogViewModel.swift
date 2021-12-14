//
//  CatalogViewModel.swift
//  auction
//
//  Created by Евгения Ренева on 03.12.2021.
//

import Foundation
import Firebase
import SwiftUI

final class CatalogViewModel: BaseViewModel {

    func fetchData() {
        firebaseManager.addLotsChangeListener { [weak self] lots in
            guard let lots = lots else { return }
            self?.lots = lots
        }
    }

    @Published var lots: [Lot] = []
}
