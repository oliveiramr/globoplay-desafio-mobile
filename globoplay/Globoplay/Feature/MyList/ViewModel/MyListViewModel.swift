//
//  MyListViewModel.swift
//  Globoplay
//
//  Created by Murilo on 19/12/24.
//

import Foundation

class MyListViewModel: ObservableObject {
    
    private let plistConfig: PlistConfig
    
    init(plistConfig: PlistConfig = PlistConfig(plistName: "Config")) {
        self.plistConfig = plistConfig
    }
    
    func getImageUrl(posterPath: String?) -> URL? {
        let baseUrl = plistConfig.getValue(forKey: "imageBaseURL200") ?? ""
        if let path = posterPath, !path.isEmpty {
            return URL(string: "\(baseUrl)\(path)")
        }
        return nil
    }
}
