//
//  HomeTabView.swift
//  Globoplay
//
//  Created by Murilo on 17/12/24.
//

import SwiftUI

enum Tab: String {
    case home = "home"
    case myList = "myList"
}

struct HomeTabView: View {
    
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            Spacer()
            HomeView()
                .tabItem {
                    Label("Início", image: "home")
                }
                .tag(Tab.home)
                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(Color.black, for: .tabBar)
            
            MyListView()
                .tabItem {
                    Label("Minha Lista", systemImage: "star.fill")
                }
                .tag(Tab.myList)
                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(Color.black, for: .tabBar)
            Spacer()
        }
        .tint(Color.white)
        .background(Color.globoPlayGray)
    }
}
