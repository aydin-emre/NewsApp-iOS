//
//  NewsAppTests.swift
//  NewsAppTests
//
//  Created by Emre on 24.12.2021.
//

import XCTest
@testable import NewsApp

class NewsAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetSources() throws {
        let expectation = expectation(description: "Service Call")

        NetworkManager.shared.sources { result in
            switch result {
            case .success(let response):
                if response.sources != nil {
                    XCTAssert(true)
                } else {
                    XCTFail("No source found!", file: #filePath, line: #line)
                }
            case .failure(let error):
                XCTFail(error.localizedDescription, file: #filePath, line: #line)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testGetTopHeadlines() throws {
        let expectation = expectation(description: "Service Call")

        let parameters = ["sources": "bbc-news"]
        NetworkManager.shared.topHeadlines(with: parameters) { result in
            switch result {
            case .success(let response):
                if !response.articles.isEmpty {
                    XCTAssert(true)
                } else {
                    XCTFail("No article found!", file: #filePath, line: #line)
                }
            case .failure(let error):
                XCTFail(error.localizedDescription, file: #filePath, line: #line)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

}
