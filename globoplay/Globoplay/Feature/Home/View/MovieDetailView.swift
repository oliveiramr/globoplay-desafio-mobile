//
//  MovieDetailView.swift
//  Globoplay
//
//  Created by Murilo on 18/12/24.
//

import SwiftUI

struct MovieDetailView: View {
    let movieId: Int
    @StateObject private var viewModel = MovieDetailViewModel()

    var body: some View {
        VStack {
            if viewModel.isLoadingImage {
                ProgressView("Carregando imagem...")
            } else if let movieImage = viewModel.movieImages {
                Image(uiImage: movieImage)
                    .resizable()
                    .frame(width: 200, height: 300)
                    .scaledToFill()
            }

            if let movieDetail = viewModel.movieDetail {
                Text(movieDetail.name ?? "")
                    .font(.largeTitle)
                    .padding()
                Text(movieDetail.overview ?? "")
                    .padding()
            } else {
                ProgressView("Carregando detalhes...")
                    .onAppear {
                        Task {
                            await viewModel.getDetail(movieId: movieId)
                            await viewModel.getImages(path: viewModel.movieDetail?.posterPath ?? "")
                        }
                    }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
