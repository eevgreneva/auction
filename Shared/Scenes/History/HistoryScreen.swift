//
//  HistoryScreen.swift
//  auction (iOS)
//
//  Created by Евгения Ренева on 10.12.2021.
//

import SwiftUI

struct HistoryScreen: View {

    @EnvironmentObject var historyViewModel: HistoryViewModel

    var body: some View {
        List(historyViewModel.history) { item in
            VStack(alignment: .leading, spacing: 4, content: {
                Text("Lot ID: \(item.lotId)")
                Text("Seller ID: \(item.sellerId)")
                Text("Byuer ID: \(item.byuerId)")
                Text("Sold price: \(item.soldPrice)")
            })
            .padding(.all, 12)
        }.onAppear {
            historyViewModel.fetchData()
        }.toolbar {
            Button("Export") {
                historyViewModel.tapExport()
            }
        }
    }
}

struct HistoryScreen_Previews: PreviewProvider {
    static var previews: some View {
        HistoryScreen()
    }
}
