//
//  FavoriteMovies.swift
//  Globoplay
//
//  Created by Murilo on 19/12/24.
//

import Foundation
import SwiftData

@Model
class FavoriteMovies {
    var id: Int
    var name: String
    var posterPath: String

    init(id: Int, name: String, posterPath: String) {
        self.id = id
        self.name = name
        self.posterPath = posterPath
    }
}
