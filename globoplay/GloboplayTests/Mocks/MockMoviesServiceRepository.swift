//
//  MockMoviesServiceRepository.swift
//  GloboplayTests
//
//  Created by Murilo on 19/12/24.
//
import SwiftUI

class MockMoviesRepository: MoviesRepositoryProtocol {
    var shouldReturnError = false
    var mockMoviesResponse: MoviesResponse?
    var mockMovieDetail: MovieDetail?
    var mockGenresResponse: GenresResponse?
    var mockImage: UIImage?

    func getMovies() async throws -> MoviesResponse {
        if shouldReturnError {
            throw NetworkError.requestFailed(NSError(domain: "", code: 0, userInfo: nil))
        }
        
        return mockMoviesResponse ?? MoviesResponse(page: 1, results: [], totalPages: 0, totalResults: 0)
    }

    func getMoviesDetails(movieId: Int) async throws -> MovieDetail {
        if shouldReturnError {
            throw NetworkError.requestFailed(NSError(domain: "", code: 0, userInfo: nil))
        }
        
        return MovieDetail(
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
    }

    func getGenres() async throws -> GenresResponse {
        if shouldReturnError {
            throw NetworkError.requestFailed(NSError(domain: "", code: 0, userInfo: nil))
        }

        return mockGenresResponse ?? GenresResponse(genres: [])
    }

    func getImage(path: String) async throws -> UIImage {
        if shouldReturnError {
            throw NetworkError.invalidURL
        }
        return UIImage(systemName: "photo") ?? UIImage() 
    }

    func loadMoreMovies() async throws -> MoviesResponse? {
        return try await getMovies()
    }

    func resetPagination() {}
}
