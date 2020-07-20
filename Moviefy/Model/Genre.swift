//
//  Genre.swift
//  Moviefy
//
//  Created by Nuno Gonçalves on 6/4/20.
//  Copyright © 2020 Nuno Gonçalves All rights reserved.
//

import Foundation

struct Genre: Decodable, Identifiable {
    let id: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
