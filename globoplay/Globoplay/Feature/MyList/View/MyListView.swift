//
//  MyListView.swift
//  Globoplay
//
//  Created by Murilo on 17/12/24.
//

import SwiftUI
import SwiftData

struct MyListView: View {
    
    @StateObject private var viewModel: MyListViewModel
    @Environment(\.modelContext) private var context
    @Query(sort: \FavoriteMovies.name) var movies: [FavoriteMovies]
    let columns = Array(repeating: GridItem(.flexible()), count: 3)
    
    init(viewModel: MyListViewModel = MyListViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if movies.isEmpty {
                    emptyStateView()
                } else {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(movies) { movie in
                            movieCard(favoriteMovie: movie)
                        }
                    }
                }
            }
            .padding(10)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Minha Lista")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                }
            }
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.globoPlayGray)
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }
    
    private func movieCard(favoriteMovie: FavoriteMovies) -> some View {
        VStack {
            if let imageUrl = viewModel.getImageUrl(posterPath: favoriteMovie.posterPath) {
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .scaledToFit()
                        .shadow(radius: 10)
                } placeholder: {
                    ProgressView()
                        .controlSize(.large)
                        .tint(Color.white)
                }
            } else {
                Text(favoriteMovie.name)
                    .foregroundColor(.white)
                    .frame(width: 135, height: 200)
                    .background(Color.black)
                    .opacity(0.8)
                    .cornerRadius(5)
            }
        }
    }
    
    private func emptyStateView() -> some View {
        VStack {
            Image("logo-globoplay-256")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
            Text("Seus favoritos irão aparecer aqui.")
                .foregroundColor(.white)
                .font(.title2.bold())
                .multilineTextAlignment(.center)
                .padding(.top, 5)
        }
        .frame(maxWidth: .infinity, maxHeight: 300)
        .padding()
    }
}
