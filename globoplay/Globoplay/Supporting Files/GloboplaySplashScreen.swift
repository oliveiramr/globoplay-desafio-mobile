//
//  GloboplaySplashScreen.swift
//  Globoplay
//
//  Created by Murilo on 19/12/24.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack {
                Image("logo-globoplay-256")
                    .resizable()
                    .scaledToFit()
                    .padding(30)
            }
        }
    }
}
