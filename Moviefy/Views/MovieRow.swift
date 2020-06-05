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
                    ZStack {
                        Circle()
                            .fill(Color.clear)
                            .frame(width: 40, height: 40)
                            .overlay (
                                Circle()
                                    .trim(from: 0, to: CGFloat(movie.vote_average * 0.1))
                                    .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                                    .fill(movie.vote_average <= 3 ? Color.red : (movie.vote_average < 7 ? Color.orange : Color.green) )
                        )
                        Text(String(format: "%.1f", movie.vote_average)).fontWeight(.semibold)
                    }
                    Spacer()
                    Text(movie.release_date).foregroundColor(.gray).bold()
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
                .placeholder(content: {
                    Text(movie.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                })
                .frame(width: 90, height: 120)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.orange, lineWidth: 2))
                .shadow(radius: 5))
        }
        
        return AnyView(Text(movie.title)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
        )
    }
}

extension Float {
	func format() -> String {
		return String(format: "%.1f",self)
	}
}
