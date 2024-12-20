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
    
    func fetchMovies() async throws -> MoviesResponse {
        return try await repository.getMovies()
    }
    
    func fetchMovieDetails(movieId: Int) async throws -> MovieDetail {
        return try await repository.getMoviesDetails(movieId: movieId)
    }
    
    func fetchGenres() async throws -> [Genre] {
        let genresResponse = try await repository.getGenres()
        return genresResponse.genres
    }
    
    func fetchImage(path: String) async throws -> UIImage {
        return try await repository.getImage(path: path)
    }
    
    func loadMoreMovies() async throws -> MoviesResponse? {
        return try await repository.loadMoreMovies()
    }
    
    func resetPagination() {
        repository.resetPagination()
    }
}
