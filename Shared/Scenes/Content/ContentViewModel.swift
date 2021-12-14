//
//  ContentViewModel.swift
//  auction
//
//  Created by Евгения Ренева on 03.12.2021.
//

import Foundation

enum AuthState {
    case loggined
    case new
}

final class ContentViewModel: BaseViewModel {

    @Published var authState: AuthState?

    func fetchData() {
        firebaseManager.addAuthListener { [weak self] auth, user in
            if let _ = auth.currentUser {
                self?.authState = .loggined
            } else {
                self?.authState = .new
            }
        }
    }
}
