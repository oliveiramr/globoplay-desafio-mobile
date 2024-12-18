//
//  MoviesRepository.swift
//  Globoplay

//  Created by Murilo on 18/12/24.
//

import Foundation

// MARK: - Error Handling

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case decodingFailed(Error)
}

// MARK: - Protocol

protocol MoviesRepositoryProtocol {
    func getMovies() async throws -> MoviesResponse
    func loadMoreMovies() async throws -> MoviesResponse?
    func resetPagination()
}

// MARK: - Movies Repository

class MoviesRepository: MoviesRepositoryProtocol {
    private let apiKey: String
    private let baseURL: String
    private var currentPage: Int = 4
    private var totalPages: Int = 0

    init() {
        let config = PlistConfig(plistName: "Config")
        self.apiKey = config.getValue(forKey: "apiKey") ?? ""
        self.baseURL = config.getValue(forKey: "baseURL") ?? ""
    }
    
    func getMovies() async throws -> MoviesResponse {
        let url = try buildURL(page: currentPage)
        let response = try await fetchData(from: url)
        totalPages = response.totalPages
        currentPage += 1
        return response
    }
    
    func loadMoreMovies() async throws -> MoviesResponse? {
        guard currentPage <= totalPages else {
            return nil
        }
        return try await getMovies()
    }

    func resetPagination() {
        currentPage = 1
        totalPages = 0
    }
    
    // MARK: - Private Methods

    private func buildURL(page: Int) throws -> URL {
        guard let url = URL(string: baseURL) else {
            throw NetworkError.invalidURL
        }

        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "include_adult", value: "false"),
            URLQueryItem(name: "include_null_first_air_dates", value: "false"),
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "sort_by", value: "popularity.desc"),
            URLQueryItem(name: "with_networks", value: "3290")
        ]

        guard let finalURL = components.url else {
            throw NetworkError.invalidURL
        }
        
        return finalURL
    }

    private func fetchData(from url: URL) async throws -> MoviesResponse {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.requestFailed(NSError(domain: "Invalid response", code: 0, userInfo: nil))
        }
        return try decodeResponse(data: data)
    }

    private func decodeResponse(data: Data) throws -> MoviesResponse {
        do {
            return try JSONDecoder().decode(MoviesResponse.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
    
    private func handleNetworkError(_ error: Error) -> NetworkError {
        if let networkError = error as? NetworkError {
            return networkError
        } else {
            return NetworkError.requestFailed(error)
        }
    }
}
