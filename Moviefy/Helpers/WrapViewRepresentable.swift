//
//  WrapViewRepresentable.swift
//  WrapViewRepresentbale
//
//  Created by Nuno Gonçalves on 29/03/2020.
//  Copyright © 2020 Nuno Gonçalves. All rights reserved.
//
import SwiftUI

protocol WrapViewRepresentable: UIViewRepresentable {
    associatedtype Wrapped: UIView
    typealias Updater = (Wrapped, Context) -> Void
    var makeView: () -> Wrapped { get }
    var update: (Wrapped, Context) -> Void { get }
}

extension WrapViewRepresentable {
    func makeUIView(context: Context) -> Wrapped {
        makeView()
    }

    func updateUIView(_ view: Wrapped, context: Context) {
        update(view, context)
    }
}
