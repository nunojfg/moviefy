//
//  HorizontalVideosView.swift
//  Moviefy
//
//  Created by Nuno Gonçalves on 24/05/2020.
//  Copyright © 2020 Liem Vo. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct HorizontalVideoListView: View {
    @ObservedObject var viewModel: VideoListViewModel
    var listName: String
    var circular: Bool
    
    init(viewModel: VideoListViewModel, listName: String = "", circular: Bool = false)  {
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
            } else if !viewModel.videos.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text(listName)
                        .font(.system(size: 24, weight: .bold))
                        .padding(.leading, 16)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(viewModel.videos) { video in
                                Button(action: {
                                    UIApplication.shared.open(URL(string: "https://www.youtube.com/watch?v=\(video.key)")!)
                                }){
                                    self.containedView(video: video)
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
    
    func containedView(video: Video) -> AnyView {
        
        if let videoPath = URL(string: String(format: BASE_VIDEO_IMAGE_URL, video.key)){
            
            if circular {
                return AnyView(WebImage(url: videoPath)
                    .resizable()
                    .placeholder(content: {
                        Text(video.name)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                    })
                    .frame(width: 150, height: 150)
                    .cornerRadius(150)
                    .overlay(Circle().stroke(Color.orange, lineWidth: 2)))
            }
            
            return AnyView(WebImage(url: videoPath)
                .resizable()
                .placeholder(content: {
                    Text(video.name)
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
        
        return AnyView(
            Text(video.name)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
        )
    }
}


