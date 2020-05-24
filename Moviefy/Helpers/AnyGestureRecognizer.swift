//
//  AnyGestureRecognizer.swift
//  Moviefy
//
//  Created by Nuno Gonçalves on 04/04/2020.
//  Copyright © 2020 Nuno Gonçalves. All rights reserved.
//

import UIKit

class AnyGestureRecognizer: UIGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        state = .began
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        state = .ended
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        state = .cancelled
    }
}
