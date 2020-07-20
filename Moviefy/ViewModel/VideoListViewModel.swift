//
//  VideoListViewModel.swift
//  Moviefy
//
//  Created by Nuno Gonçalves on 6/5/20.
//  Copyright © 2020 Liem Vo. All rights reserved.
//

import Foundation
import Combine

class VideoListViewModel: ObservableObject {
    enum State {
        case initial
        case loading
        case error
        case data
    }

    @Published var videos = [Video]()
    @Published var state: State = .initial

    private var disposables = Set<AnyCancellable>()

    init(fetcher: APIRequest<APIResponseList<Video>>) {
        self.fetchMovies(fetcher: fetcher)
    }

    private func fetchMovies(fetcher: APIRequest<APIResponseList<Video>>) {
        self.state = .loading
        APIClient().send(fetcher).sink(receiveCompletion: { (completion) in
            switch completion {
            case .failure:
                self.state = .error
                self.videos = []
            case .finished:
                break
            }
        }, receiveValue: { (response) in
            self.state = .data
            self.videos = response.results
        })
            .store(in: &disposables)
    }
}
