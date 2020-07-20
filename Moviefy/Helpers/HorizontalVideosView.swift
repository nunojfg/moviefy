//
//  HorizontalVideosView.swift
//  Moviefy
//
//  Created by Nuno Gonçalves on 24/05/2020.
//  Copyright © 2020 Liem Vo. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import AVKit
import XCDYouTubeKit

struct HorizontalVideoListView: View {
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
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
                                    self.playVideo(videoIdentifier: video.key)
                                }){
                                    self.containedView(video: video)
                                }.buttonStyle(PlainButtonStyle())
                            }
                        }
                        .frame(height: circular ? 105 : 150)
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
                    .frame(width: 100, height: 100)
                    .cornerRadius(100)
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
                .frame(width: 100, height: 150)
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
    
    func playVideo(videoIdentifier: String?) {
        let playerViewController = AVPlayerViewController()
        self.viewControllerHolder?.present(playerViewController, animated: true, completion:nil)

        XCDYouTubeClient.default().getVideoWithIdentifier(videoIdentifier) { [weak playerViewController] (video: XCDYouTubeVideo?, error: Error?) in
            if let streamURLs = video?.streamURLs, let streamURL = (streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming] ?? streamURLs[YouTubeVideoQuality.hd720] ?? streamURLs[YouTubeVideoQuality.medium360] ?? streamURLs[YouTubeVideoQuality.small240]) {
                playerViewController?.player = AVPlayer(url: streamURL)
                playerViewController?.player?.play()
            } else {
                self.viewControllerHolder?.dismiss(animated: true, completion: nil)
            }
        }
    }
}


