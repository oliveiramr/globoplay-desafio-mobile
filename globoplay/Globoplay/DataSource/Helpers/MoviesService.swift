//
//  MoviesService.swift
//  Globoplay
//
//  Created by Murilo on 18/12/24.
//

import SwiftUI

class MoviesService {
    private let repository: MoviesRepositoryProtocol
    
    init(repository: MoviesRepositoryProtocol) {
        self.repository = repository
    }
    
    // Fetch all movies for the current page
    func fetchMovies() async throws -> MoviesResponse {
        return try await repository.getMovies()
    }
    
    // Fetch movie details
    func fetchMovieDetails(movieId: Int) async throws -> MovieDetail {
        return try await repository.getMoviesDetails(movieId: movieId)
    }
    
    // Fetch genres
    func fetchGenres() async throws -> [Genre] {
        let genresResponse = try await repository.getGenres()
        return genresResponse.genres
    }
    
    // Fetch image
    func fetchImage(path: String) async throws -> UIImage {
        return try await repository.getImage(path: path)
    }
    
    // Load more movies
    func loadMoreMovies() async throws -> MoviesResponse? {
        return try await repository.loadMoreMovies()
    }
    
    // Reset pagination
    func resetPagination() {
        repository.resetPagination()
    }
}
