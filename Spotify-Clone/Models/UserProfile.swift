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
//    let Followers: [String: Codable?]
    let id: String
    let product: String
    let type: String
    let images: [UserImage]
}

struct UserImage: Codable {
    let url: String
}

//struct ExplicitContent: Codable {
//    let filter_enabled: Int
//    let filter_locked: Int
//}
//
//struct ExternalUrls: Codable {
//    let spotify: String
//}
//
//struct Followers: Codable {
//    let href: String
//    let total: Int
//}
