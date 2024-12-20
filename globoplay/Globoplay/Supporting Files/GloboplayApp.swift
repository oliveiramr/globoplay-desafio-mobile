//
//  GloboplayApp.swift
//  Globoplay
//
//  Created by Murilo on 17/12/24.
//

import SwiftUI
import SwiftData

@main
struct GloboplayApp: App {
    @State private var isSplashVisible = true
    
    var body: some Scene {
        WindowGroup {
            if isSplashVisible {
                SplashScreen()
                    .onAppear {
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                isSplashVisible = false
                            }
                        }
                    }
            } else {
                AppCoordinator().start()
            }
        }
        .modelContainer(for: FavoriteMovies.self)
    }
}
