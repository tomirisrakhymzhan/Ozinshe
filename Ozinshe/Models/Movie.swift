// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let movies = try? JSONDecoder().decode(Movies.self, from: jsonData)

import Foundation

// MARK: - Movie
struct Movie: Codable {
    let id: Int?
    let movieType, name, keyWords, description: String?
    let year: Int?
    let trend: Bool?
    let timing: Int?
    let director, producer: String?
    let poster: Poster?
    let video: Video?
    let watchCount, seasonCount, seriesCount: Int?
    let createdDate, lastModifiedDate: String?
    let screenshots: [Poster]?
    let categoryAges, genres, categories: [Category]?
    let favorite: Bool?
}

// MARK: - Category
struct Category: Codable {
    let id: Int?
    let name: String?
    let fileID: Int?
    let link: String?
    let movieCount: Int?

    enum CodingKeys: String, CodingKey {
        case id, name
        case fileID = "fileId"
        case link, movieCount
    }
}

// MARK: - Poster
struct Poster: Codable {
    let id: Int?
    let link: String?
    let fileID, movieID: Int?

    enum CodingKeys: String, CodingKey {
        case id, link
        case fileID = "fileId"
        case movieID = "movieId"
    }
}

// MARK: - Video
struct Video: Codable {
    let id: Int?
    let link: String?
    let seasonID: Int?
    let number: Int?

    enum CodingKeys: String, CodingKey {
        case id, link
        case seasonID = "seasonId"
        case number
    }
}

struct CategoryMoviesResponse: Codable {
    let content: [Movie]?
}


typealias Movies = [Movie]
typealias Categories = [Category]
