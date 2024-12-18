import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel = HomeViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    if let errorMessage = viewModel.errorMessage {
                        Text("Erro: \(errorMessage)")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        ForEach(viewModel.movies, id: \.id) { show in
                            Text(show.name ?? "")
                                .foregroundStyle(.blue)
                        }

                        if viewModel.isLoading && viewModel.movies.isEmpty {
                            ProgressView("Carregando...")
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else if !viewModel.isLoading {
                            Color.clear
                                .onAppear {
                                    Task {
                                        await viewModel.loadMoreMovies()
                                    }
                                }
                        }
                    }
                }
                .onAppear {
                    Task {
                        await viewModel.fetchMovies()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack {
                            Image("Globoplay_logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundStyle(.black)
                        }
                    }
                }

                if viewModel.isLoading && viewModel.movies.isEmpty {
                    ProgressView("Carregando...")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
    }
}
