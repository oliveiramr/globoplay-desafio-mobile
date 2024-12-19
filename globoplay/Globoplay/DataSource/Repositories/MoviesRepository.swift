//
//  MoviesRepository.swift
//  Globoplay
//
//  Created by Murilo on 18/12/24.
//

import UIKit

// MARK: - Error Handling

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case decodingFailed(Error)
}

// MARK: - Protocol

protocol MoviesRepositoryProtocol {
    func getMovies() async throws -> MoviesResponse
    func getMoviesDetails(movieId: Int) async throws -> MovieDetail
    func getGenres() async throws -> GenresResponse
    func getImage(path: String) async throws -> UIImage
    func loadMoreMovies() async throws -> MoviesResponse?
    func resetPagination()
}

// MARK: - Movies Repository

class MoviesRepository: MoviesRepositoryProtocol {

    private let apiKey: String
    private let baseURL: String
    private let detailBaseURL: String
    private let genresBaseURL: String
    private let imageBaseURL: String
    private var currentPage: Int = 4
    private var totalPages: Int = 0
    
    init() {
        let config = PlistConfig(plistName: "Config")
        self.apiKey = config.getValue(forKey: "apiKey") ?? ""
        self.baseURL = config.getValue(forKey: "baseURL") ?? ""
        self.genresBaseURL = config.getValue(forKey: "genresBaseURL") ?? ""
        self.detailBaseURL = config.getValue(forKey: "detailBaseURL") ?? ""
        self.imageBaseURL = config.getValue(forKey: "imageBaseURL") ?? ""
    }
    
    func getMovies() async throws -> MoviesResponse {
        let url = try buildMoviesURL(page: currentPage)
        let response: MoviesResponse = try await fetchData(from: url)
        totalPages = response.totalPages
        currentPage += 1
        return response
    }
    
    func getImage(path: String) async throws -> UIImage {
        
        guard let url = URL(string: imageBaseURL + path) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                throw NetworkError.requestFailed(NSError(domain: "Invalid response", code: 0, userInfo: nil))
            }
            
            guard let image = UIImage(data: data) else {
                throw NetworkError.decodingFailed(NSError(domain: "Image decoding failed", code: 0, userInfo: nil))
            }
            
            return image
        } catch {
            return UIImage(systemName: "photo") ?? UIImage()
        }
    }
    
    func getGenres() async throws -> GenresResponse {
        let url = try buildGenresURL()
        return try await fetchData(from: url)
    }
    
    func getMoviesDetails(movieId: Int) async throws -> MovieDetail {
        let url = try buildDetailURL(for: movieId)
        return try await fetchData(from: url)
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
    
    private func buildGenresURL() throws -> URL {
        guard let url = URL(string: genresBaseURL) else {
            throw NetworkError.invalidURL
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: "pt-BR")
        ]
        
        guard let finalURL = components.url else {
            throw NetworkError.invalidURL
        }
        
        return finalURL
    }
    
    private func buildDetailURL(for movieId: Int) throws -> URL {
        guard let url = URL(string: detailBaseURL + String(movieId)) else {
            throw NetworkError.invalidURL
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: "pt-BR")
        ]
        
        guard let finalURL = components.url else {
            throw NetworkError.invalidURL
        }
        
        return finalURL
    }
    
    private func buildMoviesURL(page: Int) throws -> URL {
        guard let url = URL(string: baseURL) else {
            throw NetworkError.invalidURL
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "include_adult", value: "false"),
            URLQueryItem(name: "include_null_first_air_dates", value: "false"),
            URLQueryItem(name: "language", value: "pt-BR"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "sort_by", value: "popularity.desc"),
            URLQueryItem(name: "with_networks", value: "3290")
        ]
        
        guard let finalURL = components.url else {
            throw NetworkError.invalidURL
        }
        
        return finalURL
    }
    
    private func fetchData<T: Codable>(from url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.requestFailed(NSError(domain: "Invalid response", code: 0, userInfo: nil))
        }
        return try decodeResponse(data: data)
    }
    
    private func decodeResponse<T: Codable>(data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
}
