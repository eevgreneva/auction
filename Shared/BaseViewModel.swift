//
//  BaseViewModel.swift
//  auction (iOS)
//
//  Created by Евгения Ренева on 10.12.2021.
//

import Foundation
import SwiftUI

class BaseViewModel: ObservableObject {

    @ObservedObject var firebaseManager: FirebaseManager

    init(firebaseManager: FirebaseManager) {
        self.firebaseManager = firebaseManager
    }
}
