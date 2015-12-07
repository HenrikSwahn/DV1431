import Foundation

public struct LastFMAlbumItem {
    var id: String
    var name: String
    var artist: String
    var image: String?
    var tracks: [LastFMAlbumTrackItem]?
}