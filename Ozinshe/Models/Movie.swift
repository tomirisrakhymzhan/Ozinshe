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
    let movieCount: JSONNull?

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
    let seasonID: JSONNull?
    let number: Int?

    enum CodingKeys: String, CodingKey {
        case id, link
        case seasonID = "seasonId"
        case number
    }
}

typealias Movies = [Movie]

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
    }

    public var hashValue: Int {
            return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
    }

    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
    }
}
