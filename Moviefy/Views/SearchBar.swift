//
//  SearchBar.swift
//  Moviefy
//
//  Created by Nuno Gonçalves on 21/03/2020.
//  Copyright © 2020 Nuno Gonçalves. All rights reserved.
//

import SwiftUI

struct SearchBar: WrapViewRepresentable {
    
    var makeView: () -> UISearchBar
    var update: (UISearchBar, UIViewRepresentableContext<SearchBar>) -> Void
    @Binding var text: String
    var onSearchButtonClicked: (() -> Void)? = nil

    class Coordinator: NSObject, UISearchBarDelegate {

        let control: SearchBar

        init(_ control: SearchBar) {
            self.control = control
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            control.text = searchText
            control.onSearchButtonClicked?()
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = makeView()
        searchBar.delegate = context.coordinator
        searchBar.placeholder = "Search"
        searchBar.backgroundImage = UIImage()
        searchBar.text = context.coordinator.control.text
        return searchBar
    }
}

extension SearchBar {
    
    init(text: Binding<String>,
         onSearchButtonClicked: (() -> Void)? = nil ) {
        self.makeView = { UISearchBar() }
        self.update = { _, _ in }
        self._text = text
        self.onSearchButtonClicked = onSearchButtonClicked
    }
}


