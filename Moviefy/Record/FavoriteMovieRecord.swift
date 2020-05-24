//
//  FavoriteMovieRecord.swift
//  Moviefy
//
//  Created by Nuno Gonçalves on 04/04/2020.
//  Copyright © 2020 Nuno Gonçalves. All rights reserved.
//

import Foundation
import RealmSwift

final class FavoriteMovieRecord: Object {
    @objc dynamic var popularity: Float = 0.0
    @objc dynamic var vote_count: Int = 0
    @objc dynamic var id: Int = 0
    @objc dynamic var vote_average: Float = 0.0
    @objc dynamic var title: String?
    @objc dynamic var poster_path: String?
    @objc dynamic var original_language: String?
    @objc dynamic var original_title: String?
    @objc dynamic var adult: Bool = false
    @objc dynamic var overview: String?
    @objc dynamic var release_date: String?
    @objc dynamic var added_date: String?
    @objc dynamic var media_type: String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension FavoriteMovieRecord {
    
    static func generateMovieList(from movieRecordList: [FavoriteMovieRecord]) -> [Movie] {
        let dateFormatter = ISO8601DateFormatter()
        return movieRecordList.sorted(by: { (favoriteA, favoriteB) -> Bool in
            guard let dateA = dateFormatter.date(from: favoriteA.added_date ?? ""),
                let dateB = dateFormatter.date(from: favoriteB.added_date ?? "") else {
                    return true
            }
            
            return dateA > dateB
        }).compactMap { movieRecord -> Movie? in
            return Movie(
                popularity: movieRecord.popularity,
                vote_count: movieRecord.vote_count,
                title: movieRecord.title ?? "",
                id: movieRecord.id,
                vote_average: movieRecord.vote_average,
                poster_path: movieRecord.poster_path ?? "",
                original_language: movieRecord.original_language ?? "",
                original_title: movieRecord.original_title ?? "",
                adult: movieRecord.adult,
                overview: movieRecord.overview ?? "",
                release_date: movieRecord.release_date ?? "",
                media_type: movieRecord.media_type ?? ""
            )
        }
    }
}

