//
//  MovieGridView.swift
//  Globoplay
//
//  Created by Murilo on 18/12/24.
//

import SwiftUI

struct MovieGridView: View {
    @StateObject private var viewModel: MovieGridViewModel
    
    init(viewModel: MovieGridViewModel = MovieGridViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Group {
            if viewModel.isAllMoviesLoaded {
                VStack(alignment: .leading) {
                    ForEach(viewModel.genres, id: \.id) { genre in
                        genreSection(for: genre)
                    }
                }
            } else {
                Color.globoPlayGray
            }
        }
    }
    
    private func genreSection(for genre: Genre) -> some View {
        let movies = viewModel.groupedMovies[genre] ?? []
        
        guard !movies.isEmpty else {
            return AnyView(EmptyView())
        }
        
        return AnyView(
            VStack(alignment: .leading) {
                Text(genre.name)
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .padding([.leading, .top])
                
                horizontalMovieScrollView(for: movies)
            }
        )
    }
    
    private func horizontalMovieScrollView(for movies: [Movie]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(movies, id: \.id) { movie in
                    NavigationLink(destination: MovieDetailView(movieId: movie.id ?? 0)) {
                        movieCard(for: movie)
                    }
                }
            }
            .padding()
        }
    }
    
    private func movieCard(for movie: Movie) -> some View {
        Group {
            if let imageUrl = viewModel.getImageUrl(for: movie) {
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 250)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                } placeholder: {
                    ProgressView()
                        .controlSize(.large)
                        .tint(Color.white)
                }
            } else {
                Text(movie.originalName ?? "")
                    .foregroundColor(.white)
            }
        }
        .frame(width: 150, height: 200)
        .padding()
    }
}
