//
//  WarehouseScreen.swift
//  auction
//
//  Created by Евгения Ренева on 03.12.2021.
//

import SwiftUI

struct WarehouseScreen: View {

    @EnvironmentObject var warehouseViewModel: WarehouseViewModel

    var body: some View {
        List(warehouseViewModel.lots) { lot in
            NavigationLink(destination: LotInfoScreen(lot: lot).navigationTitle(lot.title)) {
                Text(lot.title)
            }
        }.onAppear {
            warehouseViewModel.fetchData()
        }.toolbar {
            if warehouseViewModel.isAuctioneer {
                NavigationLink("Add lot", destination: AddLotScreen().navigationTitle("Add lot"))
            }
        }
    }
}

struct WarehouseScreen_Previews: PreviewProvider {
    static var previews: some View {
        WarehouseScreen()
    }
}
