//
//  ProfileViewModel.swift
//  auction
//
//  Created by Евгения Ренева on 03.12.2021.
//

import Foundation
import Firebase
import SwiftUI

final class ProfileViewModel: BaseViewModel {

    @Published var name: String = ""
    @Published var email: String = ""
    @Published var balance: Int = 0
    @Published var uid: String = ""

    func fetchData() {
        firebaseManager.addUserDataChangeListener { [weak self] user in
            self?.name = user?.firebaseUser?.displayName ?? "Unknown name"
            self?.email = user?.firebaseUser?.email ?? "Unknown email"
            self?.balance = user?.userData?.balance ?? 0
            self?.uid = user?.firebaseUser?.uid ?? "Unknown id"
        }
    }

    func tapSignOut() {
        firebaseManager.signOut()
    }
}
