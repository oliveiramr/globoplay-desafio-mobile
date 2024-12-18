//
//  HomeView.swift
//  Globoplay
//
//  Created by Murilo on 17/12/24.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        NavigationView {
            ScrollView{
                HStack{
                    Text("Início")
                }
            }
            .navigationTitle("Globoplay")
        }
    }
}
