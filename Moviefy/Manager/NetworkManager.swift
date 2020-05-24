//
//  NetworkManager.swift
//  Moviefy
//
//  Created by Nuno Gonçalves on 11/04/2020.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import Foundation
import Combine

let BASE_IMAGE_URL = "https://image.tmdb.org/t/p/w500/"

class NetworkManager: ObservableObject {
	@Published var movies = MovieList(results: [])
    @Published var tvShows = MovieList(results: [])
    @Published var recommendations = MovieList(results: [])
    @Published var moviesSearch = MovieList(results: [])
	@Published var loading = false
	private let apiKey = "6f46e665d08d9351e05b677bd8dc4515"
    private var session: URLSession {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil

        let session = URLSession.init(configuration: config)
        return session
    }
    
	init() {
        loading = true
        loadData()
    }
    
	public func loadData() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.themoviedb.org"
        urlComponents.path = "/3/discover/movie"
        urlComponents.queryItems = [
           URLQueryItem(name: "api_key", value: apiKey),
           URLQueryItem(name: "sort_by", value: "popularity.desc")
        ]
        
        guard let url = urlComponents.url else { return }
		session.dataTask(with: url){ (data, _, _) in
			guard let data = data else {
                DispatchQueue.main.async {
                    self.loading = false
                }
                return
            }
            do {
                let movies = try JSONDecoder().decode(MovieList.self, from: data)
                DispatchQueue.main.async {
                    self.movies.results = movies.results.compactMap { movie -> Movie? in
                        var movieResult = movie
                        movieResult.media_type = "movie"
                        return movieResult
                    }
                    self.loading = false
                }
            }
            catch {
                DispatchQueue.main.async {
                    self.loading = false
                }
            }
			
		}.resume()
	}
    
    public func loadDataTVShows() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.themoviedb.org"
        urlComponents.path = "/3/discover/tv"
        urlComponents.queryItems = [
           URLQueryItem(name: "api_key", value: apiKey),
           URLQueryItem(name: "sort_by", value: "popularity.desc")
        ]
        
        guard let url = urlComponents.url else { return }
        session.dataTask(with: url){ (data, _, _) in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.loading = false
                }
                return
            }
            do {
                let movies = try JSONDecoder().decode(MovieList.self, from: data)
                DispatchQueue.main.async {
                    self.tvShows.results = movies.results.compactMap { movie -> Movie? in
                        var movieResult = movie
                        movieResult.media_type = "tv"
                        return movieResult
                    }
                    self.loading = false
                }
            }
            catch {
                DispatchQueue.main.async {
                    self.loading = false
                }
            }
            
        }.resume()
    }
    
    public func loadRecommendations(movie: Movie) {
        
        let recommendationsPath = movie.media_type == "movie" ? "/3/movie/\(movie.id)/recommendations" : "/3/tv/\(movie.id)/recommendations"
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.themoviedb.org"
        urlComponents.path = recommendationsPath
        urlComponents.queryItems = [
           URLQueryItem(name: "api_key", value: apiKey),
           URLQueryItem(name: "sort_by", value: "popularity.desc")
        ]
        
        guard let url = urlComponents.url else { return }
        session.dataTask(with: url){ (data, _, _) in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.loading = false
                }
                return
            }
            do {
                let movies = try JSONDecoder().decode(MovieList.self, from: data)
                DispatchQueue.main.async {
                    self.recommendations = movies
                    self.loading = false
                }
            }
            catch {
                DispatchQueue.main.async {
                    self.loading = false
                }
            }
            
        }.resume()
    }
    
    public func loadSearchData(searchString: String) {
        self.loading = true
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.themoviedb.org"
        urlComponents.path = "/3/search/multi"
        urlComponents.queryItems = [
           URLQueryItem(name: "api_key", value: apiKey),
           URLQueryItem(name: "query", value: searchString),
           URLQueryItem(name: "sort_by", value: "popularity.desc")
        ]
        
        guard let url = urlComponents.url else { return }
        
        let task = session.dataTask(with: url){ (data, _, _) in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.moviesSearch = MovieList(results: [])
                    self.loading = false
                }
                return
            }
            do {
                let movies = try JSONDecoder().decode(MovieList.self, from: data)
                DispatchQueue.main.async {
                    self.moviesSearch = movies
                    self.loading = false
                }
            }
            catch let exception {
                
                print(exception)
                DispatchQueue.main.async {
                    self.moviesSearch = MovieList(results: [])
                    self.loading = false
                }
            }
            
        }
        
        if searchString.isEmpty || searchString.count < 3 {
            moviesSearch.results.removeAll()
            task.cancel()
        } else {
            task.resume()
        }
    }
}
