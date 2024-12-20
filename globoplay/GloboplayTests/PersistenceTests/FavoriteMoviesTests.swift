//
//  FavoriteMoviesTests.swift
//  GloboplayTests
//
//  Created by Murilo on 19/12/24.
//


import XCTest
@testable import Globoplay

class FavoriteMoviesTests: XCTestCase {
    
    func testFavoriteMoviesInitialization() {
        // Arrange
        let id = 1
        let name = "movie"
        let posterPath = "/path/to/poster.jpg"
        
        // Act
        let favoriteMovie = FavoriteMovies(id: id, name: name, posterPath: posterPath)
        
        // Assert
        XCTAssertEqual(favoriteMovie.id, id)
        XCTAssertEqual(favoriteMovie.name, name)
        XCTAssertEqual(favoriteMovie.posterPath, posterPath)
    }
    
    func testFavoriteMoviesProperties() {
        // Arrange
        let favoriteMovie = FavoriteMovies(id: 2, name: "movie", posterPath: "/path/to/poster2.jpg")
        
        // Act & Assert
        XCTAssertEqual(favoriteMovie.id, 2)
        XCTAssertEqual(favoriteMovie.name, "movie")
        XCTAssertEqual(favoriteMovie.posterPath, "/path/to/poster2.jpg")
    }
}
