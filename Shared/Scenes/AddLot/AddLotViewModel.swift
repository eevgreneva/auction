//
//  AddLotViewModel.swift
//  auction (iOS)
//
//  Created by Евгения Ренева on 08.12.2021.
//

import Foundation
import Firebase
import SwiftUI
import Combine

final class AddLotViewModel: BaseViewModel {

    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
        private var shouldDismissView = false {
            didSet {
                viewDismissalModePublisher.send(shouldDismissView)
            }
        }

    func tapAddLot(title: String, description: String, image: UIImage, price: Int) {
        firebaseManager.createLot(title: title, description: description, image: image, price: price) { [weak self] isSuccess in
            self?.shouldDismissView = true
        }
    }
}
