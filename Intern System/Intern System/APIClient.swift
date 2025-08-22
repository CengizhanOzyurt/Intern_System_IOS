//
//  APIClient.swift
//  Intern System
//
//  Created by Cengizhan Özyurt on 21.08.2025.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case badStatus(Int)
    case decoding
    case other(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Geçersiz URL."
        case .badStatus(let c): return "Sunucu hatası (\(c))."
        case .decoding: return "Veri çözümlenemedi."
        case .other(let e): return e.localizedDescription
        }
    }
}

final class APIClient {
    static let shared = APIClient()

    private let baseURL = URL(string: "http://localhost:5062")!
    private let session: URLSession = .shared
    private let jsonDecoder = JSONDecoder()
    private let jsonEncoder = JSONEncoder()

    // MARK: - Auth
    func login(email: String, password: String) async throws -> String {
        let url = baseURL.appendingPathComponent("/Home/login")
        
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try jsonEncoder.encode(LoginRequest(email: email, password: password))
        
        let (data, resp) = try await session.data(for: req)
        guard let http = resp as? HTTPURLResponse else { throw APIError.badStatus(-1) }
        guard (200..<300).contains(http.statusCode) else { throw APIError.badStatus(http.statusCode) }

        if let text = String(data: data, encoding: .utf8) {
            return text
        } else {
            throw APIError.decoding
        }
    }

    func me(accessToken: String) async throws -> UserProfile {
        let url = baseURL.appendingPathComponent("/api/users/me")
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        let (data, resp) = try await session.data(for: req)
        guard let http = resp as? HTTPURLResponse else { throw APIError.badStatus(-1) }
        guard (200..<300).contains(http.statusCode) else { throw APIError.badStatus(http.statusCode) }

        do {
            return try jsonDecoder.decode(UserProfile.self, from: data)
        } catch {
            throw APIError.decoding
        }
    }
}
