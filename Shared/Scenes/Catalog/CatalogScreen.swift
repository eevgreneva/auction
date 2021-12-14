//
//  CatalogScreen.swift
//  auction
//
//  Created by Евгения Ренева on 03.12.2021.
//

import SwiftUI

struct CatalogScreen: View {

    @EnvironmentObject var catalogViewModel: CatalogViewModel

    var body: some View {
        List(catalogViewModel.lots) { lot in
            NavigationLink(destination: LotInfoScreen(lot: lot).navigationTitle(lot.title)) {
                Text(lot.title)
            }
        }.onAppear {
            catalogViewModel.fetchData()
        }
    }
}

struct CatalogScreen_Previews: PreviewProvider {
    static var previews: some View {
        CatalogScreen()
    }
}
