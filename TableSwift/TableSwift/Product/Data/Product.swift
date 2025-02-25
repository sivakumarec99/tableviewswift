//
//  Product.swift
//  TableSwift
//
//  Created by Sivakumar R on 26/02/25.
//

import Foundation
import FirebaseFirestore

struct Product: Identifiable, Codable {
    @DocumentID var id: String?  // Firestore automatically assigns an ID
    var name: String
    var price: Double
    var description: String
    var imageUrl: String
    var userId: String  // 🔹 Required to match Firestore
    var createdAt: Date? // 🔹 Timestamp in Firestore

    // 🔹 Coding keys to match Firestore document field names exactly
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case price
        case description
        case imageUrl
        case userId
        case createdAt
    }
}
