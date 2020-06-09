//
//  APIEndpoints+Common.swift
//  Moviefy
//
//  Created by Nuno Gonçalves on 6/8/20.
//  Copyright © 2020 Liem Vo. All rights reserved.
//

import Foundation

extension APIEndpoints {
    static func videos(for movie: Movie) -> APIRequest<APIResponseList<Video>> {
        let urlPath = movie.media_type == "movie" ? "movie/\(movie.id)/videos" : "tv/\(movie.id)/videos"
        return APIRequest(path: urlPath)
    }
    static func search(text: String) -> APIRequest<APIResponseList<Movie>> {
        return APIRequest(
                path: "search/multi",
                parameters: [
                    "query": text
                ]
        )}
}
