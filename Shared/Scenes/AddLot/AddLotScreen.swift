//
//  AddLotScreen.swift
//  auction (iOS)
//
//  Created by Евгения Ренева on 08.12.2021.
//

import SwiftUI
import Combine

struct AddLotScreen: View {

    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var addLotViewModel: AddLotViewModel

    @State var showImagePicker: Bool = false

    @State var uiimage: UIImage? {
        didSet {
            guard let uiimage = uiimage else { return }
            self.image = Image(uiImage: uiimage)
        }
    }

    @State var image: Image? = nil
    @State var title: String = ""
    @State var description: String = ""
    @State var price: String = "0"

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 12) {
                image?
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300, alignment: .center)
                Button(action: {
                    self.showImagePicker.toggle()
                }) {
                    Text("Choose lot image")
                }
                TextField("Lot title", text: $title)
                TextField("Lot description", text: $description)
                TextField("Lot minimun bid", text: $price)
                    .onReceive(Just(price)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            self.price = filtered
                        }
                    }
            }
            .padding(.all, 30)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: .photoLibrary) { image in
                self.uiimage = image
            }
        }
        .toolbar {
            Button("Save") {
                guard let image = uiimage, !title.isEmpty, !description.isEmpty, let priceInt = Int(price), priceInt > 0 else {
                    return
                }

                addLotViewModel.tapAddLot(title: title, description: description, image: image, price: priceInt)
            }
            .onReceive(addLotViewModel.viewDismissalModePublisher) { shouldDismiss in
                if shouldDismiss {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }

    }
}

struct AddLotScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddLotScreen()
    }
}
