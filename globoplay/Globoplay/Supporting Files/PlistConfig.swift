//
//  PlistConfig.swift
//  Globoplay
//
//  Created by Murilo on 18/12/24.
//

import Foundation

protocol Configurable {
    func getValue(forKey key: String) -> String?
}

class PlistConfig: Configurable {
    
    private let plistName: String
    
    init(plistName: String) {
        self.plistName = plistName
    }
    
    func getValue(forKey key: String) -> String? {
        guard let url = Bundle.main.url(forResource: plistName, withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] else {
            return nil
        }
        return plist[key] as? String
    }
}
