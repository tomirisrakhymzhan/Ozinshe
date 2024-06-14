//
//  Profile.swift
//  Ozinshe
//
//  Created by Томирис Рахымжан on 13/06/2024.
//

import Foundation

struct Person: Codable {
    let birthDate: String?
    let id: Int?
    let language: String?
    let name: String?
    let phoneNumber: String?
    let user: User?
}

struct User: Codable {
    let email: String?
    let id: Int?
}
