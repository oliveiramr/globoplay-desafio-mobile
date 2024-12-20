//
//  MovieDetailViewModelTests.swift
//  Globoplay
//
//  Created by Murilo on 20/12/24.
//

import XCTest
@testable import Globoplay

class MovieDetailViewModelTests: XCTestCase {
    var viewModel: MovieDetailViewModel!
    var mockRepository: MockMoviesRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockMoviesRepository()
        viewModel = MovieDetailViewModel(repository: mockRepository)
    }

    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        super.tearDown()
    }

    func compareMovieDetails(_ lhs: MovieDetail?, _ rhs: MovieDetail?) {
        XCTAssertEqual(lhs?.adult, rhs?.adult)
        XCTAssertEqual(lhs?.backdropPath, rhs?.backdropPath)
        XCTAssertEqual(lhs?.firstAirDate, rhs?.firstAirDate)
        XCTAssertEqual(lhs?.genres, rhs?.genres)
        XCTAssertEqual(lhs?.homepage, rhs?.homepage)
        XCTAssertEqual(lhs?.id, rhs?.id)
        XCTAssertEqual(lhs?.inProduction, rhs?.inProduction)
        XCTAssertEqual(lhs?.languages, rhs?.languages)
        XCTAssertEqual(lhs?.lastAirDate, rhs?.lastAirDate)
        XCTAssertEqual(lhs?.name, rhs?.name)
        XCTAssertEqual(lhs?.originalLanguage, rhs?.originalLanguage)
        XCTAssertEqual(lhs?.originalName, rhs?.originalName)
        XCTAssertEqual(lhs?.overview, rhs?.overview)
        XCTAssertEqual(lhs?.popularity, rhs?.popularity)
        XCTAssertEqual(lhs?.posterPath, rhs?.posterPath)
        XCTAssertEqual(lhs?.status, rhs?.status)
        XCTAssertEqual(lhs?.tagline, rhs?.tagline)
        XCTAssertEqual(lhs?.type, rhs?.type)
        XCTAssertEqual(lhs?.voteAverage, rhs?.voteAverage)
        XCTAssertEqual(lhs?.voteCount, rhs?.voteCount)
    }

    func testGetDetailSuccess() async {
        let expectedDetail = MovieDetail(
            adult: false,
            backdropPath: "/mock/backdrop.jpg",
            createdBy: nil,
            episodeRunTime: nil,
            firstAirDate: "2023-01-01",
            genres: [Genre(id: 1, name: "Action")],
            homepage: "https://mockhomepage.com",
            id: 1,
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
        mockRepository.mockMovieDetail = expectedDetail

        await viewModel.getDetail(movieId: 1)

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.movieDetail)
        compareMovieDetails(viewModel.movieDetail, expectedDetail)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testGetDetailFailure() async {
        mockRepository.shouldReturnError = true
        await viewModel.getDetail(movieId: 1)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.movieDetail)
        XCTAssertEqual(viewModel.errorMessage, "The operation couldn’t be completed. (GloboplayTests.NetworkError error 0.)")
    }

    func testGetImagesSuccess() async {

        let expectedImage = UIImage(systemName: "photo")
        mockRepository.mockImage = expectedImage

        await viewModel.getImages(path: "mockPath")

        XCTAssertFalse(viewModel.isLoadingImage)
        
        if let actualImage = viewModel.movieImages {
            XCTAssertEqual(actualImage.size, expectedImage?.size)
            XCTAssertNotNil(actualImage)
        } else {
            XCTFail("movieImages should not be nil")
        }
        
        XCTAssertNil(viewModel.errorMessage)
    }

    func testGetImagesFailure() async {
        mockRepository.shouldReturnError = true

        await viewModel.getImages(path: "mockPath")

        XCTAssertFalse(viewModel.isLoadingImage)
        XCTAssertNil(viewModel.movieImages)
        XCTAssertEqual(viewModel.errorMessage, "The operation couldn’t be completed. (GloboplayTests.NetworkError error 2.)")
    }
}
