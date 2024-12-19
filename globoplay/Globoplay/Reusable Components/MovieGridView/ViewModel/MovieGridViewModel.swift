//
//  MovieGridViewModel.swift
//  Globoplay
//
//  Created by Murilo on 18/12/24.
//

import Foundation

class MovieGridViewModel: ObservableObject {
    @Published var groupedMovies: [Genre: [Movie]] = [:]
    @Published var genres: [Genre] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isAllMoviesLoaded: Bool = false

    private let moviesService: MoviesService
    private var currentPage: Int = 1
    private var totalPages: Int = 0
    private var allMovies: [Movie] = []

    init(moviesService: MoviesService = MoviesService(repository: MoviesRepository())) {
        self.moviesService = moviesService
        Task {
            await fetchGenresAndMovies()
        }
    }

    @MainActor
    func fetchGenresAndMovies() async {
        resetState()
        do {
            genres = try await moviesService.fetchGenres()
            
            while currentPage <= totalPages || totalPages == 0 {
                let moviesResponse = try await moviesService.fetchMovies()
                totalPages = moviesResponse.totalPages
                currentPage = moviesResponse.page
                
                allMovies.append(contentsOf: moviesResponse.results)
            }
            
            groupMoviesByGenre(movies: allMovies)
            isAllMoviesLoaded = true
            isLoading = false
        } catch {
            handleError(error)
        }
    }

    private func groupMoviesByGenre(movies: [Movie]) {
        groupedMovies = [:]

        for genre in genres {
            let filteredMovies = movies.filter { $0.genreIDS?.contains(genre.id) == true }
            groupedMovies[genre] = filteredMovies
        }

        let unclassifiedMovies = movies.filter { movie in
            guard let genreIDs = movie.genreIDS else { return true }
            return genreIDs.isEmpty
        }

        if !unclassifiedMovies.isEmpty {

            let othersGenreID = -1
            let othersGenreName = "Outros"
            
            if !genres.contains(where: { $0.id == othersGenreID }) {
                let othersGenre = Genre(id: othersGenreID, name: othersGenreName)
                genres.append(othersGenre)
            }

            groupedMovies[Genre(id: othersGenreID, name: othersGenreName)] = unclassifiedMovies
        }
    }

    private func handleError(_ error: Error) {
        self.errorMessage = error.localizedDescription
        isLoading = false
    }

    private func resetState() {
        self.errorMessage = nil
        self.isLoading = true
        self.groupedMovies = [:]
        self.currentPage = 1
        self.totalPages = 0
        self.isAllMoviesLoaded = false
        self.allMovies = []
    }
}
