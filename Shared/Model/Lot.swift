//
//  Lot.swift
//  auction
//
//  Created by Евгения Ренева on 03.12.2021.
//

import Foundation
import Firebase

struct Lot: Identifiable {
    var id: String
    var title: String
    var description: String
    var publicationTime: Timestamp
    var startBid: Int
    var image: String
    var ownerId: String
    var topBidUserId: String
    var topBidValue: Int
    var isSold: Bool

    init(id: String,
         title: String,
         description: String,
         publicationTime: Timestamp,
         startBid: Int,
         image: String,
         ownerId: String,
         topBidUserId: String,
         topBidValue: Int,
         isSold: Bool
    ) {

        self.id = id
        self.title = title
        self.description = description
        self.publicationTime = publicationTime
        self.startBid = startBid
        self.image = image
        self.ownerId = ownerId
        self.topBidUserId = topBidUserId
        self.topBidValue = topBidValue
        self.isSold = isSold
    }

    init?(dictionary: [String : Any], id: String) {
        guard let title = dictionary["title"] as? String,
              let description = dictionary["description"] as? String,
              let publicationTime = dictionary["publicationTime"] as? Timestamp,
              let startBid = dictionary["startBid"] as? Int,
              let image = dictionary["image"] as? String,
              let ownerId = dictionary["ownerId"] as? String,
              let topBidUserId = dictionary["topBidUserId"] as? String,
              let topBidValue = dictionary["topBidValue"] as? Int,
              let isSold = dictionary["isSold"] as? Bool
        else { return nil }

        self.init(id: id,
                  title: title,
                  description: description,
                  publicationTime: publicationTime,
                  startBid: startBid,
                  image: image,
                  ownerId: ownerId,
                  topBidUserId: topBidUserId,
                  topBidValue: topBidValue,
                  isSold: isSold)
    }

    func convertToDict() -> [String : Any] {
        var dict: [String : Any] = [:]
        dict["title"] = title
        dict["description"] = description
        dict["publicationTime"] = publicationTime
        dict["startBid"] = startBid
        dict["image"] = image
        dict["ownerId"] = ownerId
        dict["topBidUserId"] = topBidUserId
        dict["topBidValue"] = topBidValue
        dict["isSold"] = isSold
        return dict
    }
}
