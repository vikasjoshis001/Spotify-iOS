//
//  UserProfile.swift
//  Spotify-Clone
//
//  Created by Vikas Joshi on 20/11/24.
//

import Foundation

struct UserProfile: Codable {
    let country: String
    let display_name: String
    let email: String
    let explicit_content: [String: Bool]
    let external_urls: [String: String]
    let id: String
    let product: String
    let type: String
    let images: [APIImage]
}
