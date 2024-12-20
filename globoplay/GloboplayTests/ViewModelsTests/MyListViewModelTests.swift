//
//  MyListViewModelTests.swift
//  Globoplay
//
//  Created by Murilo on 20/12/24.
//

import XCTest
@testable import Globoplay

class MyListViewModelTests: XCTestCase {
    
    var viewModel: MyListViewModel!
    var mockPlistConfig: MockPlistConfig!

    override func setUp() {
        super.setUp()
        mockPlistConfig = MockPlistConfig(plistName: "configPlist")
        mockPlistConfig.mockValues["imageBaseURL200"] = "https://example.com/images/"
        viewModel = MyListViewModel(plistConfig: mockPlistConfig)
    }

    override func tearDown() {
        viewModel = nil
        mockPlistConfig = nil
        super.tearDown()
    }

    func testGetImageUrlReturnsValidURL() {
        let posterPath = "poster.jpg"
        let expectedURL = URL(string: "https://example.com/images/\(posterPath)")
        
        let result = viewModel.getImageUrl(posterPath: posterPath)
        
        XCTAssertEqual(result, expectedURL)
    }
    
    func testGetImageUrlWithEmptyPathReturnsNil() {
        let result = viewModel.getImageUrl(posterPath: "")
        
        XCTAssertNil(result)
    }
    
    func testGetImageUrlWithNilPathReturnsNil() {
        let result = viewModel.getImageUrl(posterPath: nil)

        XCTAssertNil(result)
    }
}
