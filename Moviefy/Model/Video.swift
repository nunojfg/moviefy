//
//  Video.swift
//  Moviefy
//
//  Created by Nuno Gonçalves on 24/05/2020.
//  Copyright © 2020 Nuno Gonçalves All rights reserved.
//

import Foundation

struct Video: Decodable, Identifiable, Hashable {
    var id: String
    var key: String
    var name: String
    var type: String
}
