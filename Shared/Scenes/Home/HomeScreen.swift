//
//  HomeScreen.swift
//  auction
//
//  Created by Евгения Ренева on 03.12.2021.
//

import SwiftUI

struct HomeScreen: View {

    @State private var selection: Int = 0

    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                WarehouseScreen()
                    .navigationTitle("Warehouse")
            }
            .tabItem { Label("Warehouse", systemImage: "folder") }
            .tag(0)
            NavigationView {
                CatalogScreen()
                    .navigationTitle("Catalog")

            }
            .tabItem { Label("Catalog", systemImage: "paperplane") }
            .tag(1)
            NavigationView {
                HistoryScreen()
                    .navigationTitle("History")
            }
            .tabItem { Label("History", systemImage: "doc.plaintext.fill") }
            .tag(2)
            NavigationView {
                ProfileScreen()
                    .navigationTitle("Profile")
            }
            .tabItem { Label("Profile", systemImage: "person") }
            .tag(3)
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
