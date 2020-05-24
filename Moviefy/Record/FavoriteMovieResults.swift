//
//  FavoriteMovieResults.swift
//  Moviefy
//
//  Created by Nuno Gonçalves on 04/04/2020.
//  Copyright © 2020 Nuno Gonçalves. All rights reserved.
//

import Foundation
import RealmSwift
import Combine

final class FavoriteMovieResults: ObservableObject {
    @Published var results: [Movie]
    private var token: NotificationToken!
    
    init() {
        let realm = try! Realm()
        results = FavoriteMovieRecord.generateMovieList(from: Array(realm.objects(FavoriteMovieRecord.self)))
        activateChannelsToken()
    }

    private func activateChannelsToken() {
        let realm = try! Realm()
        let resultsRecord = realm.objects(FavoriteMovieRecord.self)
        token = resultsRecord.observe { _ in
            // When there is a change, replace the old channels array with a new one.
            self.results = FavoriteMovieRecord.generateMovieList(from: Array(resultsRecord))
        }
    }
    
    deinit {
        token.invalidate()
    }
}
