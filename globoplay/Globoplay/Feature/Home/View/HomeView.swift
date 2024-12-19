//
//  HomeView.swift
//  Globoplay
//
//  Created by Murilo on 18/12/24.
//
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel = HomeViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    if let errorMessage = viewModel.errorMessage {
                        Text("Erro ao carregar os filmes: \(errorMessage)")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    ScrollView {
                        
                        MovieGridView()
                            .padding(.top, 30)
                        
                    }
                    .background(Color.globoPlayGray)
                    
                    if viewModel.isLoading && viewModel.movies.isEmpty {
                        ProgressView()
                            .controlSize(.large)
                            .tint(Color.white)
                    }
                    
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack {
                            Image("Globoplay_logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundStyle(.white)
                        }
                    }
                }
                .toolbarBackground(Color.black, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationBarTitleDisplayMode(.inline)
                
                if viewModel.isLoading && viewModel.movies.isEmpty {
                    ProgressView()
                        .controlSize(.large)
                        .tint(Color.white)
                }
            }
        }
    }
}
