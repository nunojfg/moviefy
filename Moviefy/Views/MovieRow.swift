//
//  MovieRow.swift
//  Moviefy
//
//  Created by Nuno Gonçalves on 11/04/2020.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import Combine

struct MovieRow : View {
	var movie: Movie
    var body: some View {
        HStack {
            containedView()
			VStack {
				Spacer()
				HStack {
					Text(movie.title)
						.foregroundColor(.blue)
                        .bold()
						.lineLimit(nil)
					Spacer()
				}
				HStack {
                    Text(movie.release_date).foregroundColor(.gray).bold()
					Spacer()
                    Text("Rate: \(movie.vote_average.format())").bold()
				}
				HStack {
                    Text("Vote count: \(movie.vote_count)")
						.foregroundColor(.gray)
						.lineLimit(nil)
					Spacer()
				}
				HStack {
                    Text("Popularity: \(movie.popularity.format())")
						.foregroundColor(.gray)
						.lineLimit(nil)
					Spacer()
				}
				Spacer()
			}
		}.frame(height: 130)
	}
    
    func containedView() -> AnyView {
       
        if let posterPath = movie.poster_path {
            return AnyView(WebImage(url: URL(string:  "\(BASE_IMAGE_URL)\(posterPath)")!)
                .resizable()
                .indicator(.activity)
                .frame(width: 90, height: 120)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.orange, lineWidth: 2))
                .shadow(radius: 5))
        }
        
        return AnyView(Spacer())
    }
}

extension Float {
	func format() -> String {
		return String(format: "%.1f",self)
	}
}
