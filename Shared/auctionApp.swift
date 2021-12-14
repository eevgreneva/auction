//
//  auctionApp.swift
//  Shared
//
//  Created by Евгения Ренева on 03.12.2021.
//

import SwiftUI
import Firebase
import GoogleSignIn

@main
struct auctionApp: App {

    let firebaseManager: FirebaseManager

    init() {
        FirebaseApp.configure()
        firebaseManager = FirebaseManager()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(firebaseManager)
                .environmentObject(ContentViewModel(firebaseManager: firebaseManager))
                .environmentObject(AuthViewModel(firebaseManager: firebaseManager))
                .environmentObject(ProfileViewModel(firebaseManager: firebaseManager))
                .environmentObject(CatalogViewModel(firebaseManager: firebaseManager))
                .environmentObject(LotInfoViewModel(firebaseManager: firebaseManager))
                .environmentObject(WarehouseViewModel(firebaseManager: firebaseManager))
                .environmentObject(AddLotViewModel(firebaseManager: firebaseManager))
                .environmentObject(HistoryViewModel(firebaseManager: firebaseManager))
                .onOpenURL { (url) in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
