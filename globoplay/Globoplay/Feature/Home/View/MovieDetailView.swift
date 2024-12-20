//
//  MovieDetailView.swift
//  Globoplay
//
//  Created by Murilo on 18/12/24.
//

import SwiftUI
import SwiftData

struct MovieDetailView: View {
    
    enum Segment: String, CaseIterable {
        case details = "Detalhes"
        case watchAlso = "Assista também"
    }
    
    let movieId: Int
    @ObservedObject var viewModel: MovieDetailViewModel
    @State private var selectedSegment: Segment = .details
    @State private var isAddedToMyList = false
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    @Query(sort: \FavoriteMovies.id) var favoriteMovies: [FavoriteMovies]

    init(movieId: Int, viewModel: MovieDetailViewModel = MovieDetailViewModel()) {
        self.movieId = movieId
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            ZStack {
                backgroundImageView()
                
                if viewModel.isLoadingImage || viewModel.isLoadingDetails {
                    ProgressView()
                        .controlSize(.large)
                        .tint(Color.white)
                } else {
                    VStack {
                        movieImageView()
                        movieDetailsView()
                        actionButtons()
                            .padding()
                    }
                    .padding(.top, 100)
                }
            }
            
            if let movieDetail = viewModel.movieDetail, !viewModel.isLoadingDetails {
                GPSegmentedControlView(selectedSegment: $selectedSegment, movieDetail: movieDetail)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image("baseline-arrow_back-24px")
                }
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .ignoresSafeArea(edges: .top)
        .onAppear {
            loadMovieDetails()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
    
    private func actionButtons() -> some View {
        HStack {
            GPButton(type: .watch) {
                print("Assistir filme")
            }
            GPButton(type: .myList, isAdded: $isAddedToMyList) {
                if isAddedToMyList {
                    if let movieDetail = viewModel.movieDetail {
                        if let favoriteMovie = favoriteMovies.first(where: { $0.id == movieDetail.id }) {
                            context.delete(favoriteMovie)
                        }
                    }
                    isAddedToMyList = false
                } else {
                    if let movieDetail = viewModel.movieDetail {
                        let newFav = FavoriteMovies(id: movieDetail.id ?? 0, name: movieDetail.name ?? "", posterPath: movieDetail.posterPath ?? "")
                        context.insert(newFav)
                    }
                    isAddedToMyList = true
                }
            }
        }
    }
    
    @ViewBuilder
    private func backgroundImageView() -> some View {
        if let movieImage = viewModel.movieImages,
           let posterPath = viewModel.movieDetail?.posterPath, !posterPath.isEmpty {
            Image(uiImage: movieImage)
                .resizable()
                .scaledToFill()
                .blur(radius: 10)
                .frame(maxWidth: .infinity, maxHeight: 500)
        } else {
            Color.globoPlayGray
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    @ViewBuilder
    private func movieImageView() -> some View {
        if let movieImage = viewModel.movieImages,
           let posterPath = viewModel.movieDetail?.posterPath, !posterPath.isEmpty {
            Image(uiImage: movieImage)
                .resizable()
                .frame(width: 150, height: 200)
                .shadow(radius: 10)
                .scaledToFit()
                .clipped()
        } else {
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 200)
                .foregroundColor(.gray)
        }
    }
    
    @ViewBuilder
    private func movieDetailsView() -> some View {
        if let movieDetail = viewModel.movieDetail {
            VStack(spacing: 10) {
                Text(movieDetail.name ?? "Título Indisponível")
                    .font(Font.title2.bold())
                    .foregroundColor(.white)
                    .shadow(color: Color.black, radius: 5)
                
                Text(movieDetail.overview ?? "Descrição Indisponível")
                    .foregroundColor(.white)
                    .shadow(color: Color.black, radius: 5)
            }
            .padding()
        }
    }
    
    private func loadMovieDetails() {
        Task {
            viewModel.isLoadingDetails = true
            await viewModel.getDetail(movieId: movieId)
            viewModel.isLoadingImage = true
            await viewModel.getImages(path: viewModel.movieDetail?.posterPath ?? "")
            viewModel.isLoadingDetails = false
            viewModel.isLoadingImage = false
            
            if let movieDetail = viewModel.movieDetail {
                isAddedToMyList = favoriteMovies.contains(where: { $0.id == movieDetail.id })
            }
        }
    }
}
