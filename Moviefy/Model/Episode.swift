//
//  Episode.swift
//  Moviefy
//
//  Created by Nuno Gonçalves on 6/4/20.
//  Copyright © 2020 Nuno Gonçalves All rights reserved.
//

import Foundation

struct Episode: Decodable {
    let id: Int
    let name: String?
    let airDate: String?
    let episodeNumber: Int
    let overview: String?
    let seasonNumber: Int
    let stillPath: String?
    let voteAverage: Double
    let voteCount: Int

    var stillUrl: URL? {
           guard let stillPath = stillPath else {
               return nil
           }
           let url = URL(string: "\(APIClient.baseImageStringUrl)\(stillPath)")
           return url
       }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case airDate = "air_date"
        case episodeNumber = "episode_number"
        case overview
        case seasonNumber = "season_number"
        case stillPath = "still_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
