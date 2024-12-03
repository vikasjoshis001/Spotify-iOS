//
//  CategoryResponse.swift
//  Spotify-Clone
//
//  Created by Vikas Joshi on 28/11/24.
//

import Foundation

struct CategoryResponse: Codable {
    let categories: Category
}

struct Category: Codable {
    let items: [CategoryItems]
}

struct CategoryItems: Codable {
    let href: String
    let icons: [APIImage]
    let id: String
    let name: String
}
