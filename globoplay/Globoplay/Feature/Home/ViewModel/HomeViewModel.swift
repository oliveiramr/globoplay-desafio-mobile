//
//  HomeViewModel.swift
//  Globoplay
//
//  Created by Murilo on 18/12/24.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let repository: MoviesRepositoryProtocol

    init(repository: MoviesRepositoryProtocol = MoviesRepository()) {
        self.repository = repository
    }

    // MARK: - Public Methods

    @MainActor
    func fetchMovies() async {
        resetState()
        await loadMovies()
    }

    @MainActor
    func loadMoreMovies() async {
        guard !isLoading else { return }
        isLoading = true
        
        await loadMovies()
    }

    // MARK: - Private Methods

    @MainActor
    private func loadMovies() async {
        do {
            let response: MoviesResponse
            
            if movies.isEmpty {
                response = try await repository.getMovies()
            } else {
                response = try await repository.loadMoreMovies() ?? MoviesResponse(page: 0, results: [], totalPages: 0, totalResults: 0)
            }

            movies.append(contentsOf: response.results)
            isLoading = false
        } catch {
            handleError(error)
        }
    }

    private func handleError(_ error: Error) {
        self.errorMessage = error.localizedDescription
        isLoading = false
    }

    private func resetState() {
        self.errorMessage = nil
        self.isLoading = true
    }
}
