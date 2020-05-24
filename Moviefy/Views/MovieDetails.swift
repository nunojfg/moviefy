//
//  MovieDetails.swift
//  Moviefy
//
//  Created by Nuno Gonçalves on 11/04/2020.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import SwiftUI
import RealmSwift
import SDWebImageSwiftUI

struct MovieDetails : View {
    @State private var isFavorite: Bool = false
    var movie: Movie
    
    var body: some View {
        VStack {
            ScrollView {
                containedView()
                HStack {
                    Text("Description")
                        .font(.system(size: 24, weight: .bold))
                    Spacer()
                }
                Spacer()
                Text(movie.overview).lineLimit(nil)
                Spacer()
                HorizontalMoviesListView(movie: movie)
            }
        }
        .navigationBarTitle(Text(movie.title), displayMode: .large)
        .padding()
        .onAppear {
            let realm = try! Realm()
            let results = realm.objects(FavoriteMovieRecord.self).filter("id == \(self.movie.id)")
            self.isFavorite = !results.isEmpty
        }
        .navigationBarItems(trailing:
            Button(action: {
                let realm = try! Realm()
                let results = realm.objects(FavoriteMovieRecord.self).filter("id == \(self.movie.id)")
                if let result = results.first {
                    try! realm.write {
                        realm.delete(result)
                    }
                } else {
                    try! realm.write {
                        realm.add(self.movie.toRecord(), update: .all)
                    }
                }
                
                self.isFavorite.toggle()
            }){
                favoriteButtonView()
            }
        )
    }
    
    func containedView() -> AnyView {
        
        if let posterPath = movie.poster_path {
            return AnyView(WebImage(url: URL(string:"\(BASE_IMAGE_URL)\(posterPath)")!)
                .resizable()
                .indicator(.activity)
                .frame(width: UIScreen.main.bounds.height / 8 * 3, height: UIScreen.main.bounds.height / 2)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.orange, lineWidth: 2))
                .shadow(radius: 10))
        }
        
        return AnyView(Spacer())
    }
    
    func favoriteButtonView() -> AnyView {
        return AnyView(
            HStack {
                Image(systemName: isFavorite ? "star.fill" : "star")
            }.padding(10.0)
        )
    }
}

