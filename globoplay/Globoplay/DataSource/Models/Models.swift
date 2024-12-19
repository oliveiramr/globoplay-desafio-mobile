//
//  Models.swift
//  Globoplay
//
//  Created by Murilo on 18/12/24.
//

import Foundation

// MARK: - MoviesResponse
struct MoviesResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results 
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Movie
struct Movie: Codable, Equatable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originCountry: [OriginCountry]?
    let originalLanguage: OriginalLanguage?
    let originalName, overview: String?
    let popularity: Double?
    let posterPath, firstAirDate, name: String?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case firstAirDate = "first_air_date"
        case name
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

// MARK: - GenresResponse
struct GenresResponse: Codable {
    let genres: [Genre]
}

// MARK: - Genre
struct Genre: Codable, Hashable {
    let id: Int
    let name: String
}

enum OriginCountry: String, Codable {
    case br = "BR"
}

enum OriginalLanguage: String, Codable {
    case pt = "pt"
}

// MARK: - MovieDetail
struct MovieDetail: Codable {
    let adult: Bool?
    let backdropPath: String?
    let createdBy: [Creator]?
    let episodeRunTime: [Int]?
    let firstAirDate: String?
    let genres: [Genre]?
    let homepage: String?
    let id: Int?
    let inProduction: Bool?
    let languages: [String]?
    let lastAirDate: String?
    let lastEpisodeToAir: EpisodeDetail?
    let name: String?
    let nextEpisodeToAir: EpisodeDetail?
    let networks: [Network]?
    let numberOfEpisodes: Int?
    let numberOfSeasons: Int?
    let originCountry: [String]?
    let originalLanguage: String?
    let originalName: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let seasons: [Season]?
    let spokenLanguages: [SpokenLanguage]?
    let status: String?
    let tagline: String?
    let type: String?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case createdBy = "created_by"
        case episodeRunTime = "episode_run_time"
        case firstAirDate = "first_air_date"
        case genres
        case homepage
        case id
        case inProduction = "in_production"
        case languages
        case lastAirDate = "last_air_date"
        case lastEpisodeToAir = "last_episode_to_air"
        case name
        case nextEpisodeToAir = "next_episode_to_air"
        case networks
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview
        case popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case seasons
        case spokenLanguages = "spoken_languages"
        case status
        case tagline
        case type
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

// MARK: - Creator
struct Creator: Codable {
    // Propriedades necessárias para o criador, se disponíveis
}

// MARK: - EpisodeDetail
struct EpisodeDetail: Codable {
    let id: Int?
    let name: String?
    let overview: String?
    let voteAverage: Double?
    let voteCount: Int?
    let airDate: String?
    let episodeNumber: Int?
    let episodeType: String?
    let productionCode: String?
    let runtime: Int?
    let seasonNumber: Int?
    let showId: Int?
    let stillPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case overview
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case airDate = "air_date"
        case episodeNumber = "episode_number"
        case episodeType = "episode_type"
        case productionCode = "production_code"
        case runtime
        case seasonNumber = "season_number"
        case showId = "show_id"
        case stillPath = "still_path"
    }
}

// MARK: - Network
struct Network: Codable {
    let id: Int?
    let logoPath: String?
    let name: String?
    let originCountry: String?

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}

// MARK: - ProductionCompany
struct ProductionCompany: Codable {
    let id: Int?
    let logoPath: String?
    let name: String?
    let originCountry: String?

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}

// MARK: - ProductionCountry
struct ProductionCountry: Codable {
    let iso3166_1: String?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}

// MARK: - Season
struct Season: Codable {
    let airDate: String?
    let episodeCount: Int?
    let id: Int?
    let name: String?
    let overview: String?
    let posterPath: String?
    let seasonNumber: Int?
    let voteAverage: Double?

    enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case episodeCount = "episode_count"
        case id
        case name
        case overview
        case posterPath = "poster_path"
        case seasonNumber = "season_number"
        case voteAverage = "vote_average"
    }
}

// MARK: - SpokenLanguage
struct SpokenLanguage: Codable {
    let englishName: String?
    let iso639_1: String?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
}
