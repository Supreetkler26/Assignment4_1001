//
//  Movie.swift
//  Assignment4_1001
//
//  Created by Ravi  on 2023-08-11.
//

import Foundation

struct Movie: Codable {
    var documentID: String?
    var movieID: Int
    var title: String
    var studio: String
    var mpaRating: String
    var criticsRating: CriticRating 
    var imgURL: String?
    
    enum CodingKeys: String, CodingKey {
        case documentID
        case movieID
        case title
        case studio
        case mpaRating
        case criticsRating
        case imgURL
    }
}


enum CriticRating: Codable {
    case string(String)
    case double(Double)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else if let doubleValue = try? container.decode(Double.self) {
            self = .double(doubleValue)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode CriticRating")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let stringValue):
            try container.encode(stringValue)
        case .double(let doubleValue):
            try container.encode(doubleValue)
        }
    }
}



//struct Movie: Codable {
//    var documentID: String?
//    var movieID: Int
//    var title: String?
//    var studio: String?
////    var year: Int
//    var mpaRating: String?
//    var criticsRating: String?
//    var imgURL : String?
//
//    enum CodingKeys: String, CodingKey {
//           case documentID
//           case movieID
//           case title
//           case studio
//           case mpaRating
//           case criticsRating
//           case imgURL
//       }
//}
