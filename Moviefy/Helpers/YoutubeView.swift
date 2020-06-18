//
//  YoutubeView.swift
//  Moviefy
//
//  Created by Nuno Gonçalves on 6/15/20.
//  Copyright © 2020 Liem Vo. All rights reserved.
//

import Foundation
import SwiftUI
import XCDYouTubeKit

struct YoutubeView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    
    func makeUIViewController(context: Context) -> XCDYouTubeVideoPlayerViewController {
        return XCDYouTubeVideoPlayerViewController(videoIdentifier: "")
    }
    
    func updateUIViewController(_ uiViewController: UIFontPickerViewController, context: Context) {
        
    }
}
