//
//  NewReleases.swift
//  Spotify-Clone
//
//  Created by Vikas Joshi on 25/11/24.
//

import Foundation

// MARK: - NewReleasesResponse

struct NewReleasesResponse: Codable {
    let albums: AlbumsResponse
}

// MARK: - AlbumsResponse

struct AlbumsResponse: Codable {
    let items: [Album]
}

// MARK: - Album

struct Album: Codable {
    let album_type: String
    let available_markets: [String]
    let id: String
    let images: [APIImage]
    let name: String
    let release_date: String
    let total_tracks: Int
    let artists: [Artist]
}
