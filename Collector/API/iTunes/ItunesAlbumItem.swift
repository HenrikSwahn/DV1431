import Foundation

public struct ItunesAlbumItem: CustomStringConvertible {
    var id: String
    var name: String
    var artist: String
    var image: String?
    var release: String
    var genre: String
    var tracks: [ItunesAlbumTrackItem]?
    
    public var description: String {
        get {
            if tracks != nil {
                return "id: \(id), name: \(name) artist: \(artist) image: \(image) date: \(release) genre: \(genre)\nTracks:\n\(tracks!)"
            } else {
                return "id: \(id), name: \(name) artist: \(artist) image: \(image) date: \(release) genre: \(genre)\n"
            }
        }
    }
}