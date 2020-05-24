//
//  Wrap.swift
//  Wrap
//
//  Created by Nuno Gonçalves on 29/03/2020.
//  Copyright © 2020 Nuno Gonçalves. All rights reserved.
//

import SwiftUI

struct Wrap<Wrapped: UIView>: WrapViewRepresentable {
    
    var makeView: () -> Wrapped
    var update: (Wrapped, UIViewRepresentableContext<Wrap<Wrapped>>) -> Void

    init(_ makeView: @escaping @autoclosure () -> Wrapped,
         updater update: @escaping Updater) {
        self.makeView = makeView
        self.update = update
    }
}

extension Wrap {
    init(_ makeView: @escaping @autoclosure () -> Wrapped,
         updater update: @escaping (Wrapped) -> Void) {
        self.makeView = makeView
        self.update = { view, _ in update(view) }
    }

    init(_ makeView: @escaping @autoclosure () -> Wrapped) {
        self.makeView = makeView
        self.update = { _, _ in }
    }
}
