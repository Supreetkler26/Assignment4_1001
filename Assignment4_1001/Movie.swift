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
    var title: String?
    var studio: String?
    var mpaRating: String?
    var criticsRating: Double
    var imgURL: String?

    
    }

   


//
//struct Movie: Codable {
//    var documentID: String?
//    var movieID: Int
//    var title: String?
//    var studio: String?
////    var year: Int
//    var mpaRating: String?
//    var criticsRating: Any
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


