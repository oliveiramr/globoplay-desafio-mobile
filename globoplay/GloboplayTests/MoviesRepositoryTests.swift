//
//  MoviesRepositoryTests.swift
//  Globoplay
//
//  Created by Murilo on 19/12/24.
//

import XCTest
@testable import Globoplay

class MoviesRepositoryTests: XCTestCase {
    
    var repository: MoviesRepository!

    override func setUp() {
        super.setUp()
        repository = MoviesRepository()
    }
    
    override func tearDown() {
        repository = nil
        super.tearDown()
    }
    
    func testGetMoviesSuccess() async throws {
        let moviesResponse = try await repository.getMovies()
        XCTAssertNotNil(moviesResponse)
        XCTAssertGreaterThan(moviesResponse.results.count, 0)
    }
    
    func testGetMoviesDetailsSuccess() async throws {
        let movieId = 1
        let movieDetail = try await repository.getMoviesDetails(movieId: movieId)
        XCTAssertNotNil(movieDetail)
        XCTAssertEqual(movieDetail.id, movieId)
    }
    
    func testGetMoviesDetailsFailure() async throws {
        let invalidMovieId = -1
        
        do {
            let _ = try await repository.getMoviesDetails(movieId: invalidMovieId)
            XCTFail("Expected error, but got success.")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
    
    func testGetGenresSuccess() async throws {
        let genresResponse = try await repository.getGenres()
        XCTAssertNotNil(genresResponse)
        XCTAssertGreaterThan(genresResponse.genres.count, 0)
    }
    
    func testGetImageSuccess() async throws {
        let imagePath = "/path/to/image.jpg"
        let image = try await repository.getImage(path: imagePath)
        XCTAssertNotNil(image)
    }
}
