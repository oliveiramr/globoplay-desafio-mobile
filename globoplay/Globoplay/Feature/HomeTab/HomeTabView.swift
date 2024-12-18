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
            
            MyListView()
                .tabItem {
                    Label("Minha Lista", image: "baseline_star_rate_black_24")
                    
                }
                .tag(Tab.myList)
            
            Spacer()
        }
    }
}
