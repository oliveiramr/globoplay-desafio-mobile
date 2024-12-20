//
//  MoviesServiceTests.swift
//  GloboplayTests
//
//  Created by Murilo on 19/12/24.
//

import Foundation
import XCTest
@testable import Globoplay

class MoviesServiceTests: XCTestCase {
    
    var service: MoviesService!
    var mockRepository: MockMoviesRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockMoviesRepository()
        service = MoviesService(repository: mockRepository)
    }

    override func tearDown() {
        service = nil
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

        let response = try await service.fetchMovies()
        XCTAssertNotNil(response)
        XCTAssertEqual(response.results.count, 1)
        XCTAssertEqual(response.results.first?.name, "Mock Movie")
    }
    
    func testFetchMoviesFailure() async throws {
        mockRepository.shouldReturnError = true
        
        do {
            let _ = try await service.fetchMovies()
            XCTFail("Expected error, but got success.")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
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
        
        let detail = try await service.fetchMovieDetails(movieId: movieId)
        XCTAssertNotNil(detail)
        XCTAssertEqual(detail.id, movieId)
        XCTAssertEqual(detail.name, "Mock Movie Detail")
    }
    
    func testFetchMovieDetailsFailure() async throws {
        mockRepository.shouldReturnError = true
        
        do {
            let _ = try await service.fetchMovieDetails(movieId: -1)
            XCTFail("Expected error, but got success.")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }

    func testFetchGenresSuccess() async throws {
        let mockGenresResponse = GenresResponse(genres: [Genre(id: 1, name: "Action")])
        mockRepository.mockGenresResponse = mockGenresResponse
        
        let genres = try await service.fetchGenres()
        XCTAssertNotNil(genres)
        XCTAssertEqual(genres.count, 1)
        XCTAssertEqual(genres.first?.name, "Action")
    }
    
    func testFetchGenresFailure() async throws {
        mockRepository.shouldReturnError = true
        
        do {
            let _ = try await service.fetchGenres()
            XCTFail("Expected error, but got success.")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }

    func testFetchImageSuccess() async throws {
        let imagePath = "/path/to/image.jpg" // Substitua pelo caminho de imagem válido
        let image = try await service.fetchImage(path: imagePath) // Chama o método da service
        XCTAssertNotNil(image) // Verifica se a imagem não é nula
    }

    func testFetchImageFailure() async throws {
        mockRepository.shouldReturnError = true // Configura o mock para retornar um erro
        
        do {
            let _ = try await service.fetchImage(path: "") // Chama o método da service
            XCTFail("Expected error, but got success.") // Se não lançar erro, falha o teste
        } catch {
            XCTAssertTrue(error is NetworkError) // Verifica se o erro é do tipo esperado
        }
    }
}
