//
//  AuthViewModel.swift
//  auction
//
//  Created by Евгения Ренева on 03.12.2021.
//

import Foundation
import Firebase
import SwiftUI

final class AuthViewModel: BaseViewModel {

    func tapAuth() {
        firebaseManager.authWithGoogle()
    }
}
