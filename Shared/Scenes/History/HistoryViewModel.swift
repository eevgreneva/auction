//
//  HistoryViewModel.swift
//  auction (iOS)
//
//  Created by Евгения Ренева on 10.12.2021.
//

import Foundation
import SwiftUI

final class HistoryViewModel: BaseViewModel {

    @Published var history: [SellHistoryItem] = []

    func fetchData() {
        firebaseManager.addSellsChangeListener { [weak self] items in
            self?.history = items ?? []
        }
    }

    func tapExport() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootView = windowScene.windows.first?.rootViewController else { return }

        var result: String = ""

        history.forEach {
            result.append(contentsOf: "Lot Id: \($0.lotId); Byuer Id: \($0.byuerId); Seller Id: \($0.sellerId); Price: \($0.soldPrice)\n")
        }

        let filename = getDocumentsDirectory().appendingPathComponent("salesHistory-\(UUID().uuidString).txt")

        do {
            try result.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }

        let activityVC = UIActivityViewController(activityItems: [filename], applicationActivities: nil)
        rootView.present(activityVC, animated: true, completion: nil)
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
