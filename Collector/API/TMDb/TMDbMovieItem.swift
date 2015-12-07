import Foundation

public struct TMDbMovieItem {
    var id: Int
    var image: String
    var release_date: String
    var language: String
    var title: String
    var synopsis: String
    var cast: [String]
    var genres: [String]
}