//
//  MovieDetailViewModel.swift
//  Globoplay
//
//  Created by Murilo on 18/12/24.
//

import SwiftUI

class MovieDetailViewModel: ObservableObject {
    @Published var movieDetail: MovieDetail?
    @Published var movieImages: UIImage?
    @Published var isLoading: Bool = false
    @Published var isLoadingImage: Bool = false
    @Published var isLoadingDetails: Bool = false
    @Published var errorMessage: String?

    private let repository: MoviesRepositoryProtocol

    init(repository: MoviesRepositoryProtocol = MoviesRepository()) {
        self.repository = repository
    }

    @MainActor
    func getDetail(movieId: Int) async {
        isLoading = true
        errorMessage = nil

        do {
            let response = try await repository.getMoviesDetails(movieId: movieId)
            movieDetail = response
        } catch {
            handleError(error)
        }
        
        isLoading = false
    }
    
    @MainActor
    func getImages(path: String) async {
        isLoadingImage = true
        errorMessage = nil

        do {
            let response = try await repository.getImage(path: path)
            movieImages = response
        } catch {
            handleError(error)
        }
        
        isLoadingImage = false
    }

    private func handleError(_ error: Error) {
        self.errorMessage = error.localizedDescription
    }
}
