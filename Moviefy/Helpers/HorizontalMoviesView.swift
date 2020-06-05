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
    @ObservedObject var viewModel: MovieListViewModel
    var listName: String
    var circular: Bool
    
    init(viewModel: MovieListViewModel, listName: String = "", circular: Bool = false)  {
        self.viewModel = viewModel
        self.listName = listName
        self.circular = circular
    }
    
    var body: some View {
        Group {
            if viewModel.state == .loading {
                VStack(alignment: .leading, spacing: 10) {
                    ShimmerView().frame(height: 32)
                    ShimmerView().frame(height: 245)
                }.padding([.leading, .trailing], 10)
            } else if !viewModel.movies.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text(listName)
                        .font(.system(size: 24, weight: .bold))
                        .padding(.leading, 16)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(viewModel.movies) { movie in
                                NavigationLink(destination: MovieDetails(movie: movie)){
                                    Group {
                                        self.containedView(movie: movie)
                                    }
                                }.buttonStyle(PlainButtonStyle())
                            }
                        }
                        .frame(height: circular ? 155 : 245)
                        .padding([.leading, .trailing], 10)
                    }
                }
            } else {
                Rectangle().fill(Color.clear)
            }
        }.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5)))
    }
    
    func containedView(movie: Movie) -> AnyView {
        
        if let posterPath = movie.poster_path {
            
            if circular {
                return AnyView(WebImage(url: URL(string: "\(BASE_IMAGE_URL)\(posterPath)")!)
                    .resizable()
                    .placeholder(content: {
                        Text(movie.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                    })
                    .frame(width: 150, height: 150)
                    .cornerRadius(150)
                    .overlay(Circle().stroke(Color.orange, lineWidth: 2)))
            }
            
            return AnyView(WebImage(url: URL(string: "\(BASE_IMAGE_URL)\(posterPath)")!)
                .resizable()
                .placeholder(content: {
                    Text(movie.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                })
                .frame(width: 150, height: 245)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.orange, lineWidth: 2))
                .shadow(radius: 5))
        }
        
        return AnyView(
            Text(movie.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
        )
    }
}
