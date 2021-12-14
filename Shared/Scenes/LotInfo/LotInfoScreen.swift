//
//  LotInfoScreen.swift
//  auction
//
//  Created by Евгения Ренева on 03.12.2021.
//

import SwiftUI
import Combine

struct LotInfoScreen: View {

    @EnvironmentObject var lotInfoViewModel: LotInfoViewModel

    @State private var showingBidAlert = false
    @State private var showingBalanceAlert = false

    @State var lot: Lot
    @State var bid: String = "0"

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 8) {
                if let image = lotInfoViewModel.lotImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300, alignment: .center)
                }
                Text(lot.title)
                    .font(.title)
                Text(lot.description)
                    .font(.body)
                Spacer(minLength: 20)
                if lotInfoViewModel.isAuctioneer {
                    if lot.topBidValue != 0, !lot.isSold {
                        Text("Current Offer: \(lot.topBidValue)")
                        Button("Accept Offer") {
                            lotInfoViewModel.acceptBid(lot: lot) { lot in
                                self.lot = lot
                            }
                        }
                    } else {
                        Text("There are no offer on this lot yet")
                    }
                } else {
                    if lot.isSold {

                    } else {
                        Text("Minimum offer: \(lot.startBid)")
                        Text("Current offer: \(lot.topBidValue)")
                        TextField("Your offer", text: $bid)
                            .onReceive(Just(bid)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.bid = filtered
                                }
                            }
                        Button("Make offer") {
                            if let bid = Int(bid), bid > lot.startBid, bid > lot.topBidValue {

                                if bid > lotInfoViewModel.balance {
                                    showingBalanceAlert = true
                                } else {
                                    lotInfoViewModel.makeBid(lot: lot, bid: bid) { lot in
                                        self.lot = lot
                                    }
                                }
                            } else {
                                showingBidAlert = true
                            }
                        }
                    }
                }
            }.onAppear {
                lotInfoViewModel.loadImage(with: lot.image)
            }
            .alert("Your bid must be greater than the minimum and greater than the current one", isPresented: $showingBidAlert) {
                Button("OK", role: .cancel) { }
            }
            .alert("There is not enough funds in your account to set a offer", isPresented: $showingBalanceAlert) {
                Button("OK", role: .cancel) { }
            }
            .padding(.top, 30)
            .padding(.leading, 12)
            .padding(.trailing, 12)
            .padding(.bottom, 30)
        }
    }
}

struct LotInfoScreen_Previews: PreviewProvider {
    static var previews: some View {
        LotInfoScreen(lot: .init(id: "", title: "", description: "", publicationTime: .init(seconds: 0, nanoseconds: 0), startBid: 0, image: "", ownerId: "", topBidUserId: "", topBidValue: 0, isSold: false))
    }
}
