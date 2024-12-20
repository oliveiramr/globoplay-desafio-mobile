//
//  HomeViewModelTests.swift
//  GloboplayTests
//
//  Created by Murilo on 19/12/24.
//

import XCTest
@testable import Globoplay

class HomeViewModelTests: XCTestCase {
    
    var viewModel: HomeViewModel!
    var mockRepository: MockMoviesRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockMoviesRepository()
        let service = MoviesService(repository: mockRepository)
        viewModel = HomeViewModel(moviesService: service)
    }

    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        super.tearDown()
    }

    func testFetchMoviesSuccess() async throws {
        let mockMovie = Movie(
            adult: false,
            backdropPath: "/mock/backdrop.jpg",
            genreIDS: [1],
            id: 1,
            originCountry: nil,
            originalLanguage: nil,
            originalName: "Mock Movie Original",
            overview: "This is a mock overview.",
            popularity: 10.0,
            posterPath: "/mock/path.jpg",
            firstAirDate: "2023-01-01",
            name: "Mock Movie",
            voteAverage: 8.5,
            voteCount: 100
        )
        
        let mockResponse = MoviesResponse(page: 1, results: [mockMovie], totalPages: 1, totalResults: 1)
        mockRepository.mockMoviesResponse = mockResponse

        await viewModel.fetchMovies()
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.movies)
        XCTAssertEqual(viewModel.movies.count, 1)
        XCTAssertEqual(viewModel.movies.first?.name, "Mock Movie")
    }
    
    func testFetchMoviesFailure() async throws {
        mockRepository.shouldReturnError = true
        
        await viewModel.fetchMovies()
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
    }

    func testFetchGenresSuccess() async throws {
        let mockGenres = [Genre(id: 1, name: "Action")]
        mockRepository.mockGenresResponse = GenresResponse(genres: mockGenres)
        
        await viewModel.getGenres()
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.genres.count, 1)
        XCTAssertEqual(viewModel.genres.first?.name, "Action")
    }
    
    func testFetchGenresFailure() async throws {
        mockRepository.shouldReturnError = true
        
        await viewModel.getGenres()
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
    }

    func testFetchMovieDetailsSuccess() async throws {
        let movieId = 1
        let mockDetail = MovieDetail(
            adult: false,
            backdropPath: "/mock/backdrop.jpg",
            createdBy: nil,
            episodeRunTime: nil,
            firstAirDate: "2023-01-01",
            genres: [Genre(id: 1, name: "Action")],
            homepage: "https://mockhomepage.com",
            id: movieId,
            inProduction: false,
            languages: ["en"],
            lastAirDate: nil,
            lastEpisodeToAir: nil,
            name: "Mock Movie Detail",
            nextEpisodeToAir: nil,
            networks: nil,
            numberOfEpisodes: nil,
            numberOfSeasons: nil,
            originCountry: ["US"],
            originalLanguage: "en",
            originalName: "Mock Movie Original",
            overview: "This is a detailed mock overview.",
            popularity: 10.0,
            posterPath: "/mock/path.jpg",
            productionCompanies: nil,
            productionCountries: nil,
            seasons: nil,
            spokenLanguages: nil,
            status: "Released",
            tagline: "This is a mock tagline.",
            type: "movie",
            voteAverage: 8.5,
            voteCount: 100
        )
        
        mockRepository.mockMovieDetail = mockDetail
        
        await viewModel.getDetail(movieId: movieId)
        XCTAssertNotNil(viewModel.movieDetails)
        XCTAssertEqual(viewModel.movieDetails?.id, movieId)
        XCTAssertEqual(viewModel.movieDetails?.name, "Mock Movie Detail")
    }
    
    func testFetchMovieDetailsFailure() async throws {
        mockRepository.shouldReturnError = true
        
        await viewModel.getDetail(movieId: -1)
        XCTAssertNotNil(viewModel.errorMessage)
    }

    func testFetchImageSuccess() async throws {
        let imagePath = "/path/to/image.jpg"
        let mockImage = UIImage(systemName: "photo")
        mockRepository.mockImage = mockImage
        
        await viewModel.getMovieImage(path: imagePath)
        XCTAssertNotNil(viewModel.movieImage)
    }

    func testFetchImageFailure() async throws {
        mockRepository.shouldReturnError = true
        
        await viewModel.getMovieImage(path: "")
        XCTAssertNotNil(viewModel.errorMessage)
    }
}
