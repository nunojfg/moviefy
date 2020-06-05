//
//  TVSeason.swift
//  Moviefy
//
//  Created by Nuno Gonçalves on 6/4/20.
//  Copyright © 2020 Liem Vo. All rights reserved.
//

import Foundation

struct TVSeason: Decodable {
    let id: Int
    let name: String
    let overview: String?
    let seasonNumber: Int
    let posterPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case overview
        case seasonNumber = "season_number"
        case posterPath = "poster_path"
    }
}
