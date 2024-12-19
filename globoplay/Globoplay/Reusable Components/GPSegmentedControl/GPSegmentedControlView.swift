//
//  GPSegmentedControlView.swift
//  Globoplay
//
//  Created by Murilo on 19/12/24.
//

import SwiftUI

struct GPSegmentedControlView: View {
    @Binding var selectedSegment: MovieDetailView.Segment
    var movieDetail: MovieDetail
    
    var body: some View {
        VStack {
            segmentedPicker
            
            switch selectedSegment {
            case .watchAlso, .details:
                detailsContent
            }
        }
        .background(Color.globoPlayGray)
    }
    
    private var segmentedPicker: some View {
        Picker("Segment", selection: $selectedSegment) {
            ForEach(MovieDetailView.Segment.allCases, id: \.self) { segment in
                Text(segment.rawValue)
                    .tag(segment)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }
    
    private var detailsContent: some View {
        VStack(alignment: .leading, spacing: 10) {
            detailText(title: "Nome:", value: movieDetail.name ?? "Indisponível")
            detailText(title: "Data de Lançamento:", value: movieDetail.firstAirDate ?? "Indisponível")
            detailText(title: "Origem:", value: movieDetail.originCountry?.first ?? "Indisponível")
            detailText(title: "Status:", value: movieDetail.status ?? "Indisponível")
            detailText(title: "Tipo:", value: movieDetail.type ?? "Indisponível")
            detailText(title: "Popularidade:", value: "\(movieDetail.popularity ?? 0.0)")
            detailText(title: "Última vez no ar:", value: movieDetail.lastAirDate ?? "Indisponível")
            detailText(title: "Tempo do episódio / Filme:", value: "\(movieDetail.episodeRunTime?.first ?? 0) Min")
            detailText(title: "Homepage:", value: movieDetail.homepage ?? "Indisponível")
        }
        .padding()
    }
    
    private func detailText(title: String, value: String) -> some View {
        Text("\(title) \(value)")
            .foregroundColor(.white)
            .shadow(color: Color.black, radius: 5)
    }
}
