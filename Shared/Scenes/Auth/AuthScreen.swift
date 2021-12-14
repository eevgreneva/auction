//
//  AuthScreen.swift
//  auction
//
//  Created by Евгения Ренева on 03.12.2021.
//

import SwiftUI
import GoogleSignIn

struct AuthScreen: View {

    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            SignInButton()
                .onTapGesture {
                    authViewModel.tapAuth()
                }
        }
        .padding(.top, 64)
        .padding(.leading, 24)
        .padding(.trailing, 24)
    }
}

struct SignInButton: UIViewRepresentable {

    func makeUIView(context: Context) -> GIDSignInButton {
        let button = GIDSignInButton()
        button.colorScheme = .light
        button.style = .wide
        return button
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

struct AuthScreen_Previews: PreviewProvider {
    static var previews: some View {
        AuthScreen()
    }
}
