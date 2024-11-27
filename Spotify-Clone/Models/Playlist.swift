//
//  Playlist.swift
//  Spotify-Clone
//
//  Created by Vikas Joshi on 20/11/24.
//

import Foundation

// MARK: - PlaylistResponse

struct PlaylistResponse: Codable {
    let items: [Playlist]
}

// MARK: - Playlist

struct Playlist: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let owner: Owner
}

// MARK: - Owner

struct Owner: Codable {
    let display_name: String
    let external_urls: [String: String]
    let id: String
}
