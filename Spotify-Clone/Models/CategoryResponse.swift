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
//    let href: String
//    let limit: Int
//    let next: String?
//    let offset: Int
//    let previous: String?
//    let total: Int
    let items: [CategoryItems]
}

struct CategoryItems: Codable {
    let href: String
    let icons: [APIImage]
    let id: String
    let name: String
}

//{
//    categories =     {
//        href = "https://api.spotify.com/v1/browse/categories?offset=0&limit=20&locale=en-IN,en-GB;q%3D0.9,en;q%3D0.8";
//        items =         (
//                        {
//                href = "https://api.spotify.com/v1/browse/categories/0JQ5DAt0tbjZptfcdMSKl3";
//                icons =                 (
//                                        {
//                        height = 274;
//                        url = "https://t.scdn.co/images/728ed47fc1674feb95f7ac20236eb6d7.jpeg";
//                        width = 274;
//                    }
//                );
//                id = 0JQ5DAt0tbjZptfcdMSKl3;
//                name = "Made For You";
//            },
//                        {
//                href = "https://api.spotify.com/v1/browse/categories/0JQ5DAqbMKFz6FAsUtgAab";
//                icons =                 (
//                                        {
//                        height = 274;
//                        url = "https://t.scdn.co/images/728ed47fc1674feb95f7ac20236eb6d7.jpeg";
//                        width = 274;
//                    }
//                );
//                id = 0JQ5DAqbMKFz6FAsUtgAab;
//                name = "New Releases";
//            }
//        );
//        limit = 20;
//        next = "https://api.spotify.com/v1/browse/categories?offset=20&limit=20&locale=en-IN,en-GB;q%3D0.9,en;q%3D0.8";
//        offset = 0;
//        previous = "<null>";
//        total = 66;
//    };
//}
