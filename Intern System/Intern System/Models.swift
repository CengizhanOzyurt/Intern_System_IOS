//
//  Models.swift
//  Intern System
//
//  Created by Cengizhan Özyurt on 21.08.2025.
//

import Foundation

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct LoginResponse: Codable {
    let message: String?
    let userId: Int
    let firstName: String
    let lastName: String
}

struct UserProfile: Codable {
    let firstName: String
    let lastName: String
}
