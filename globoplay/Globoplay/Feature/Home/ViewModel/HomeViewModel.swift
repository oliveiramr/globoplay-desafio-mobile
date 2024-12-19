//
//  HomeViewModel.swift
//  Globoplay
//
//  Created by Murilo on 18/12/24.
//

import UIKit

class HomeViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var movieDetails: MovieDetail? = nil
    @Published var movieImage: UIImage? = nil
    @Published var genres: [Genre] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let moviesService: MoviesService

    init(moviesService: MoviesService = MoviesService(repository: MoviesRepository())) {
        self.moviesService = moviesService
    }

    // MARK: - Public Methods

    @MainActor
    func fetchMovies() async {
        resetState()
        await getMovies()
    }

    @MainActor
    func loadMoreMovies() async {
        guard !isLoading else { return }
        isLoading = true

        await getMovies()
    }

    // MARK: - Private Methods

    @MainActor
    private func getMovies() async {
        do {
            let response: [Movie]
            
            if movies.isEmpty {
                response = try await moviesService.fetchMovies().results
            } else {
                response = try await moviesService.loadMoreMovies()?.results ?? []
            }

            movies.append(contentsOf: response)
            isLoading = false
        } catch {
            handleError(error)
        }
    }

    @MainActor
    func getGenres() async {
        do {
            let response = try await moviesService.fetchGenres()
            self.genres = response
        } catch {
            handleError(error)
        }
    }

    @MainActor
    func getDetail(movieId: Int) async {
        do {
            let response = try await moviesService.fetchMovieDetails(movieId: movieId)
            self.movieDetails = response
        } catch {
            handleError(error)
        }
    }

    @MainActor
    func getMovieImage(path: String) async {
        do {
            let response = try await moviesService.fetchImage(path: path)
            self.movieImage = response
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
