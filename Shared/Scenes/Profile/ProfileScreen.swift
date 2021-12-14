//
//  ProfileScreen.swift
//  auction
//
//  Created by Евгения Ренева on 03.12.2021.
//

import SwiftUI
import Combine

struct ProfileScreen: View {

    @EnvironmentObject var profileViewModel: ProfileViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 12) {
                Spacer()
                Image(systemName: "person")
                    .resizable()
                    .frame(width: 100, height: 100)
                Text(profileViewModel.name)
                    .font(.title)
                Text("Email: \(profileViewModel.email)")
                    .font(.body)
                Text("User ID: \(profileViewModel.uid)")
                    .font(.body)
                Text("Balance: \(profileViewModel.balance)$")
                    .font(.body)
            }
            .onAppear {
                profileViewModel.fetchData()
            }
            .padding(.top, 30)
        }
        .toolbar {
            Button("Logout") {
                profileViewModel.tapSignOut()
            }
        }
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}
