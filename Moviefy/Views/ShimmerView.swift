//
//  ShimmerView.swift
//  Moviefy
//
//  Created by Nuno Gonçalves on 6/5/20.
//  Copyright © 2020 Liem Vo. All rights reserved.
//

import SwiftUI

struct ShimmerView: View {

    @State private var opacity: Double = 0.25

    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color(.darkGray))
            .opacity(opacity)
            .transition(.opacity)
            .onAppear {
                let baseAnimation = Animation.easeInOut(duration: 0.9)
                let repeated = baseAnimation.repeatForever(autoreverses: true)
                withAnimation(repeated) {
                    self.opacity = 1
                }
        }
    }
}
