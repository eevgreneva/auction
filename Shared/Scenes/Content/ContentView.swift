//
//  ContentView.swift
//  Shared
//
//  Created by Евгения Ренева on 03.12.2021.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var contentViewModel: ContentViewModel

    var body: some View {
        Group {
            switch contentViewModel.authState ?? .new {
            case .loggined:
                HomeScreen()
            case .new:
                AuthScreen()
            }
        }
        .onAppear {
            contentViewModel.fetchData()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ContentViewModel(firebaseManager: FirebaseManager()))
    }
}
