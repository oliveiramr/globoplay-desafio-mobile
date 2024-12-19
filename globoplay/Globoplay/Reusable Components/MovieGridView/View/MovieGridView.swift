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
                        if let movies = viewModel.groupedMovies[genre], !movies.isEmpty {
                            Text(genre.name)
                                .font(.headline)
                                .padding(.leading)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    let columns = [GridItem(.flexible())]

                                    LazyHGrid(rows: columns, spacing: 0) {
                                        ForEach(movies, id: \.id) { movie in
                                            NavigationLink(destination: MovieDetailView(movieId: movie.id ?? 0)) {
                                                VStack {
                                                    if let imageUrl = movie.posterPath ?? movie.backdropPath, let url = URL(string: "https://image.tmdb.org/t/p/w200\(imageUrl)") {
                                                        AsyncImage(url: url) { image in
                                                            image
                                                                .resizable()
                                                                .scaledToFit()
                                                                .frame(width: 200, height: 250)
                                                                .cornerRadius(10)
                                                        } placeholder: {
                                                            ProgressView()
                                                        }
                                                    } else {
                                              
                                                        Text(movie.originalName ?? "")
                                                    }
                                                }
                                                .frame(width: 150, height: 200)
                                                .padding()
                                            }
                                        }
                                    }
                                    .padding()
                                }
                            }
                        }
                    }
                }
            } else {
                ProgressView("Carregando filmes...")
            }
        }
    }
}
