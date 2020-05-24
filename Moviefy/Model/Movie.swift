//
//  Movie.swift
//  Moviefy
//
//  Created by Nuno Gonçalves on 11/04/2020.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import Foundation
import RealmSwift

struct Movie: Decodable, Identifiable, Hashable {
	var popularity: Float
	var vote_count: Int
	var id: Int
	var vote_average: Float
	var title: String
	var poster_path: String?
	var original_language: String
	var original_title: String
	var adult: Bool
	var overview: String
	var release_date: String
    var media_type: String
    
    enum CodingKeys: String, CodingKey {
        case popularity = "popularity"
        case vote_count = "vote_count"
        case id = "id"
        case vote_average = "vote_average"
        case title = "title"
        case name = "name"
        case poster_path = "poster_path"
        case original_language = "original_language"
        case original_title = "original_title"
        case adult = "adult"
        case overview = "overview"
        case first_air_date = "first_air_date"
        case release_date = "release_date"
        case original_name = "original_name"
        case media_type = "media_type"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.popularity = try container.decode(Float.self, forKey: .popularity)
        self.vote_count = try container.decodeIfPresent(Int.self, forKey: .vote_count) ?? 0
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.id = try container.decode(Int.self, forKey: .id)
        self.vote_average = try container.decodeIfPresent(Float.self, forKey: .vote_average) ?? 0
        self.poster_path = try container.decodeIfPresent(String.self, forKey: .poster_path) ?? ""
        self.original_language = try container.decodeIfPresent(String.self, forKey: .original_language) ?? ""
        self.original_title = try container.decodeIfPresent(String.self, forKey: .original_title) ?? container.decodeIfPresent(String.self, forKey: .original_name) ?? ""
        self.adult = try container.decodeIfPresent(Bool.self, forKey: .adult) ?? false
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview) ?? ""
        self.release_date = try container.decodeIfPresent(String.self, forKey: .release_date) ??
            container.decodeIfPresent(String.self, forKey: .first_air_date) ?? ""
        self.media_type = try container.decodeIfPresent(String.self, forKey: .media_type) ?? "movie"
    }
    
    init(popularity: Float,
         vote_count: Int,
         title: String,
         id: Int,
         vote_average: Float,
         poster_path: String,
         original_language: String,
         original_title: String,
         adult: Bool,
         overview: String,
         release_date: String,
         media_type: String) {
        
        self.popularity = popularity
        self.vote_count = vote_count
        self.title = title
        self.id = id
        self.vote_average = vote_average
        self.poster_path = poster_path
        self.original_language = original_language
        self.original_title = original_title
        self.adult = adult
        self.overview = overview
        self.release_date = release_date
        self.media_type = media_type
    }
}

extension Movie {
    func toRecord() -> FavoriteMovieRecord {
        let movieRecord = FavoriteMovieRecord()
        movieRecord.id = self.id
        movieRecord.adult = self.adult
        movieRecord.original_language = self.original_language
        movieRecord.original_title = self.original_title
        movieRecord.overview = self.overview
        movieRecord.popularity = self.popularity
        movieRecord.poster_path = self.poster_path
        movieRecord.release_date = self.release_date
        movieRecord.title = self.title
        movieRecord.vote_average = self.vote_average
        movieRecord.vote_count = self.vote_count
        movieRecord.media_type = self.media_type
        movieRecord.added_date = ISO8601DateFormatter().string(from: Date())
        
        return movieRecord
    }
}
