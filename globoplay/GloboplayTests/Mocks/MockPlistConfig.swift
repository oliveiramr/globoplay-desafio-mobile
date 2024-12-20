//
//  MockPlistConfig.swift
//  Globoplay
//
//  Created by Murilo on 20/12/24.
//

import Foundation

final class MockPlistConfig: PlistConfig {
    var mockValues: [String: String] = [:]

    override init(plistName: String) {
        super.init(plistName: plistName)
    }

    override func getValue(forKey key: String) -> String? {
        return mockValues[key]
    }
}
