//
//  AlbumDetailsResponse.swift
//  Spotify-Clone
//
//  Created by Vikas Joshi on 03/12/24.
//

import Foundation

struct AlbumDetails: Codable {
    let album_type: String
    let artists: [Artist]
    let available_markets: [String]
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let label: String
    let tracks: TracksResponse
}

struct TracksResponse: Codable {
    let items: [AudioTrack]
}
