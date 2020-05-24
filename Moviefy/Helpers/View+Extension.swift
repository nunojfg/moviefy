//
//  View+Extension.swift
//  Moviefy
//
//  Created by Nuno Gonçalves on 28/03/2020.
//  Copyright © 2020 Nuno Gonçalves. All rights reserved.
//

import SwiftUI

extension View {
    
    func cardContained(cornerRadius: CGFloat = 8) -> some View {
        self
        .padding(.all)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(cornerRadius)
    }
}
