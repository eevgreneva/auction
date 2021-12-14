//
//  DatabaseManager.swift
//  auction
//
//  Created by Евгения Ренева on 03.12.2021.
//

import Foundation
import Firebase
import FirebaseStorage
import SwiftUI
import GoogleSignIn

class AuctionUser: ObservableObject {
    var firebaseUser: User?
    var userData: UserData?

    var isAuctioneer: Bool {
        userData?.userType == .auctioneer
    }

    init(firebaseUser: User? = nil, userData: UserData? = nil) {
        self.firebaseUser = firebaseUser
        self.userData = userData
    }
}

final class FirebaseManager: ObservableObject {

    private let auth = Auth.auth()
    private let firestore: Firestore = Firestore.firestore()
    private let firebaseStorage: FirebaseStorage.Storage = Storage.storage()

    var user: AuctionUser = .init()

    func addAuthListener(handle: @escaping (Auth, User?) -> Void) {
        auth.addStateDidChangeListener { [weak self] auth, user in
            handle(auth, user)

            guard let user = user else { return }

            self?.user.firebaseUser = user

            self?.firestore.collection("users").addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error getting users: \(error)")
                } else {
                    guard let userDocument = querySnapshot?.documents.first(where: { $0.documentID == user.uid }),
                          let userData = UserData(dictionary: userDocument.data(), id: userDocument.documentID) else {
                        print("Error parsing user")
                        return
                    }

                    self?.user.userData = userData
                }
            }
        }
    }

    func addUserDataChangeListener(handle: @escaping (AuctionUser?) -> Void) {
        firestore.collection("users").addSnapshotListener { [weak self] (querySnapshot, error) in
            if let error = error {
                print("Error getting users: \(error)")
                handle(nil)
            } else {
                guard let documents = querySnapshot?.documents else {
                    print("No users")
                    handle(nil)
                    return
                }
                let users = documents.compactMap { document -> UserData? in
                    return UserData(dictionary: document.data(), id: document.documentID)
                }
                handle(AuctionUser(firebaseUser: self?.auth.currentUser, userData: users.first(where: { $0.id == self?.auth.currentUser?.uid })))
            }
        }
    }

    func addLotsChangeListener(handle: @escaping ([Lot]?) -> Void) {
        firestore.collection("lots").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error getting lots: \(error)")
                handle(nil)
            } else {
                guard let documents = querySnapshot?.documents else {
                    print("No lots")
                    handle(nil)
                    return
                }
                let lots = documents.compactMap { document -> Lot? in
                    return Lot(dictionary: document.data(), id: document.documentID)
                }
                handle(lots.filter({ $0.isSold == false }))
            }
        }
    }

    func addWarehouseChangeListener(handle: @escaping ([Lot]?) -> Void) {
        firestore.collection("lots").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error getting lots: \(error)")
                handle(nil)
            } else {
                guard let documents = querySnapshot?.documents else {
                    print("No lots")
                    handle(nil)
                    return
                }
                let lots = documents.compactMap { document -> Lot? in
                    return Lot(dictionary: document.data(), id: document.documentID)
                }
                handle(lots.filter({ $0.ownerId == self.auth.currentUser?.uid }))
            }
        }
    }

    func makeBid(for lot: Lot, bid: Int, completion: @escaping (Lot) -> Void) {
        guard bid > lot.topBidValue, bid > lot.startBid, let uid = auth.currentUser?.uid else { completion(lot); return }

        var editedLot = lot
        editedLot.topBidValue = bid
        editedLot.topBidUserId = uid

        firestore.collection("lots").document(lot.id).setData(editedLot.convertToDict(), completion: { error in
            if let error = error {
                print("\(error.localizedDescription)")
                completion(lot)
            } else {
                completion(editedLot)
            }
        })
    }

    func acceptBid(for lot: Lot, completion: @escaping (Lot, Bool) -> Void) {
        guard lot.isSold == false, lot.startBid > 0, let ownUid = auth.currentUser?.uid, let ownUser = user.userData else { completion(lot, false); return }

        var editedLot = lot
        editedLot.isSold = true
        editedLot.ownerId = lot.topBidUserId

        let sellId = UUID().uuidString

        let historyItem = SellHistoryItem(id: sellId, byuerId: lot.topBidUserId, soldPrice: lot.topBidValue, lotId: lot.id, sellerId: lot.ownerId)

        var isSuccess: Bool = true

        let group = DispatchGroup()

        group.enter()
        firestore.collection("lots").document(lot.id).setData(editedLot.convertToDict(), completion: { error in
            if let error = error {
                print("\(error.localizedDescription)")
                isSuccess = false
            }
            group.leave()
        })

        group.enter()
        firestore.collection("users").document(lot.topBidUserId).getDocument { [weak self] (document, error) in
            if let document = document, document.exists, let userData = UserData(dictionary: document.data() ?? [:], id: document.documentID)  {

                var newUserData = userData
                newUserData.balance = userData.balance - lot.topBidValue

                self?.firestore.collection("users").document(lot.topBidUserId).setData(newUserData.convertToDict(), completion: { error in
                    if let error = error {
                        print("\(error.localizedDescription)")
                        isSuccess = false
                    }

                    group.leave()
                })
            } else {
                isSuccess = false
                group.leave()
            }
        }

        var newOwnUserData = ownUser
        newOwnUserData.balance = ownUser.balance + lot.topBidValue

        group.enter()
        firestore.collection("users").document(ownUid).setData(newOwnUserData.convertToDict(), completion: { error in
            if let error = error {
                print("\(error.localizedDescription)")
                isSuccess = false
            }

            group.leave()
        })

        group.enter()
        firestore.collection("history").document(sellId).setData(historyItem.convertToDict(), completion: { error in
            if let error = error {
                print("\(error.localizedDescription)")
                isSuccess = false
            }
            group.leave()
        })

        group.notify(queue: .main) {
            completion(isSuccess ? editedLot : lot, isSuccess)
        }
    }

    func addSellsChangeListener(handle: @escaping ([SellHistoryItem]?) -> Void) {
        firestore.collection("history").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error getting lots: \(error)")
                handle(nil)
            } else {
                guard let documents = querySnapshot?.documents else {
                    print("No history")
                    handle(nil)
                    return
                }
                let history = documents.compactMap { document -> SellHistoryItem? in
                    return SellHistoryItem(dictionary: document.data(), id: document.documentID)
                }
                handle(history)
            }
        }
    }

    func loadLotImage(with name: String, completion: @escaping (UIImage?) -> Void) {
        let imagePath = firebaseStorage.reference().child("lotsImages").child(name)

        imagePath.getData(maxSize: 4096 * 4096) { (data, error) -> Void in
            if let data = data {
                completion(UIImage(data: data))
            } else if let _ = error {
                completion(nil)
            }
        }
    }

    func createLot(title: String, description: String, image: UIImage, price: Int, completion: @escaping (Bool) -> Void) {
        guard let usedId = auth.currentUser?.uid else { completion(false); return }

        let lotId = UUID().uuidString
        let lot = Lot(id: lotId,
                      title: title,
                      description: description,
                      publicationTime: Timestamp(seconds: Int64(NSDate().timeIntervalSince1970), nanoseconds: 0),
                      startBid: price,
                      image: "\(lotId)",
                      ownerId: usedId,
                      topBidUserId: "",
                      topBidValue: 0,
                      isSold: false)

        var isSuccess: Bool = true

        let group = DispatchGroup()

        group.enter()
        firestore.collection("lots").document(lotId).setData(lot.convertToDict(), completion: { error in
            if let error = error {
                print("\(error.localizedDescription)")
                isSuccess = false
            }
            group.leave()
        })

        group.enter()
        uploadLotImage(image: image, lotId: lotId) { isSuccessed in
            if !isSuccessed {
                isSuccess = false
            }
            group.leave()
        }

        group.notify(queue: .main, execute: {
            completion(isSuccess)
        })
    }

    func uploadLotImage(image: UIImage, lotId: String , completion: @escaping (Bool) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { completion(false); return }

        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"

        firebaseStorage.reference().child("lotsImages/\(lotId)").putData(imageData, metadata: metaData){ (metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            } else {
                completion(true)
            }
        }
    }

    func authWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID,
              let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootView = windowScene.windows.first?.rootViewController else { return }

        GIDSignIn.sharedInstance.signIn(with: GIDConfiguration(clientID: clientID), presenting: rootView) { [weak self] user, error in
            if let _ = error { return }
            guard let authentication = user?.authentication,  let idToken = authentication.idToken else { return }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)

            self?.auth.signIn(with: credential) { [weak self] result, error in
                guard let result = result else { print("\(error?.localizedDescription ?? "Unknown error when sign in")"); return }

                let uid = result.user.uid

                self?.user.firebaseUser = result.user

                self?.firestore.collection("users").document(uid).getDocument { (document, error) in

                    if let document = document, document.exists, let userData = UserData(dictionary: document.data() ?? [:], id: document.documentID)  {
                        self?.user.userData = userData
                    } else {
                        let newUserData = UserData(id: uid, balance: 0, userType: .user)
                        self?.firestore.collection("users").document(uid).setData(newUserData.convertToDict(), completion: { error in
                            if let error = error {
                                print("\(error.localizedDescription)")
                            } else {
                                self?.user.userData = newUserData
                            }
                        })
                    }
                }
            }
        }
    }

    func signOut() {
        do {
            try auth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
