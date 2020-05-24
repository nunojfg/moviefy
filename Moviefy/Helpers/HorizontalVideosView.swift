//
//  HorizontalVideosView.swift
//  Moviefy
//
//  Created by Nuno Gonçalves on 24/05/2020.
//  Copyright © 2020 Liem Vo. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct HorizontalVideosView: View {
    @ObservedObject var networkManager = NetworkManager()
    
    init(movie: Movie) {
        networkManager.loadVideos(movie: movie)
    }
    
    var body: some View {
        Group {
            if !networkManager.videoList.results.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Videos")
                        .font(.system(size: 24, weight: .bold))
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(networkManager.videoList.results) { video in
                                Button(action: {
                                    UIApplication.shared.open(URL(string: "https://www.youtube.com/watch?v=\(video.key)")!)
                                }){
                                    self.containedView(video: video)
                                }.buttonStyle(PlainButtonStyle())
                            }
                        }
                        .frame(height: 120)
                        .padding([.leading, .trailing], 10)
                    }
                }
            }
        }.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5)))
    }
    
    func containedView(video: Video) -> AnyView {
        
        if let videoPath = URL(string: String(format: BASE_VIDEO_IMAGE_URL, video.key)){
            return AnyView(WebImage(url: videoPath)
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

