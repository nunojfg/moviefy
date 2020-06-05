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
let BASE_VIDEO_IMAGE_URL = "https://img.youtube.com/vi/%@/default.jpg"

class NetworkManager: ObservableObject {
	@Published var movies = MovieList(results: [])
    @Published var tvShows = MovieList(results: [])
    @Published var recommendations = MovieList(results: [])
    @Published var moviesSearch = MovieList(results: [])
    @Published var videoList = VideoList(results: [])
	@Published var loading = false
	private let apiKey = "6f46e665d08d9351e05b677bd8dc4515"
    private var session: URLSession {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil

        let session = URLSession.init(configuration: config)
        return session
    }
    private var disposables = Set<AnyCancellable>()
    
	init() {
        loading = true
        loadData()
    }
    
    public func fetchMovies(fetcher: APIRequest<APIResponseList<Movie>>) {
        loading = true
        APIClient().send(fetcher).sink(receiveCompletion: { (completion) in
            switch completion {
            case .failure:
                self.loading = false
            case .finished:
                break
            }
        }, receiveValue: { (response) in
            self.loading = false
            self.movies.results = response.results
        }).store(in: &disposables)
    }
    
	public func loadData() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.themoviedb.org"
        urlComponents.path = "/3/discover/movie"
        urlComponents.queryItems = [
           URLQueryItem(name: "api_key", value: apiKey),
           URLQueryItem(name: "sort_by", value: "popularity.desc"),
           URLQueryItem(name: "certification_country", value: "US"),
            URLQueryItem(name: "certification.lte", value: "g"),
            URLQueryItem(name: "include_adult", value: "false")
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
                    self.recommendations.results = movies.results.compactMap { movieParsed -> Movie? in
                        var movieResult = movieParsed
                        movieResult.media_type = movie.media_type
                        return movieResult
                    }
                }
            }
            catch {
                DispatchQueue.main.async {
                    self.loading = false
                }
            }
            
        }.resume()
    }
    
    public func loadVideos(movie: Movie) {
        
        let videosPath = movie.media_type == "movie" ? "/3/movie/\(movie.id)/videos" : "/3/tv/\(movie.id)/videos"
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.themoviedb.org"
        urlComponents.path = videosPath
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
                let videos = try JSONDecoder().decode(VideoList.self, from: data)
                DispatchQueue.main.async {
                    self.videoList = videos
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
