//
//  AboutView.swift
//  Moviefy
//
//  Created by Nuno Gonçalves on 28/03/2020.
//  Copyright © 2020 Nuno Gonçalves. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    
    let about: About = About.defaultAbout
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        Text(about.title)
                            .font(.body)
                            .cardContained()
                        
                        ForEach(about.copyrights) { copy in
                            VStack(alignment: .leading, spacing: 8) {
                                SectionCardView(title: copy.title, subtitle: copy.license)
                            }
                        }
                    }
                    .padding(.all)
                }
            }
            .navigationBarTitle("About")
            .background(Color(UIColor.secondarySystemBackground))
        }
    }
}
