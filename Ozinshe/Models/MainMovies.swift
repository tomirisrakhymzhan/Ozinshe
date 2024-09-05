//
//  MainMovies.swift
//  Ozinshe
//
//  Created by Томирис Рахымжан on 20/08/2024.
//

import Foundation
struct MainMovie: Codable {
    let categoryID: Int?
    let categoryName: String?
    let movies: [Movie]?

    enum CodingKeys: String, CodingKey {
        case categoryID = "categoryId"
        case categoryName, movies
    }
}
typealias MainMovies = [MainMovie]
