//
//  HomeMovieListViewModel.swift
//  Moviefy
//
//  Created by Nuno Gonçalves on 6/4/20.
//  Copyright © 2020 Liem Vo. All rights reserved.
//

import Foundation
import Combine

class GenresMovieListViewModel: ObservableObject {
    enum State {
        case initial
        case loading
        case error
        case data
    }

    @Published var genres = [Genre]()
    @Published var state: State = .initial

    private var disposables = Set<AnyCancellable>()

    init(endpoint: APIRequest<APIResponseGenres>) {
        self.fetchGenres(endpoint: endpoint)
    }

    private func fetchGenres(endpoint: APIRequest<APIResponseGenres>) {
        self.state = .loading
        APIClient().send(endpoint).sink(receiveCompletion: { (completion) in
            switch completion {
            case .failure:
                self.state = .error
                self.genres = []
            case .finished:
                break
            }
        }, receiveValue: { (response) in
            self.state = .data
            self.genres = response.genres
        })
        .store(in: &disposables)
    }
}
