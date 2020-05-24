//
//  HorizontalMoviesView.swift
//  Moviefy
//
//  Created by Nuno Gonçalves on 22/05/2020.
//  Copyright © 2020 Liem Vo. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct HorizontalMoviesListView: View {
    @ObservedObject var networkManager = NetworkManager()
    
    init(movie: Movie) {
        networkManager.loadRecommendations(movie: movie)
    }
    
    var body: some View {
        Group {
            if !networkManager.recommendations.results.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Recommendations")
                        .font(.system(size: 24, weight: .bold))
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(networkManager.recommendations.results) { movie in
                                NavigationLink(destination: MovieDetails(movie: movie)){
                                    Group {
                                        self.containedView(movie: movie)
                                    }
                                }.buttonStyle(PlainButtonStyle())
                            }
                        }
                        .frame(height: 245)
                        .padding([.leading, .trailing], 10)
                    }
                }
            }
        }.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5)))
    }
    
    func containedView(movie: Movie) -> AnyView {
        
        if let posterPath = movie.poster_path {
            return AnyView(WebImage(url: URL(string: "\(BASE_IMAGE_URL)\(posterPath)")!)
                .resizable()
                .indicator(.activity)
                .frame(width: 150, height: 245)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.orange, lineWidth: 2))
                .shadow(radius: 5))
        }
        
        return AnyView(Spacer())
    }
}
