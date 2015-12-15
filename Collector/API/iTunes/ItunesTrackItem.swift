import Foundation

public struct ItunesAlbumTrackItem: CustomStringConvertible {
    var title: String
    var artist: String
    var duration: String
    var url: String?
    
    public var description: String {
        get {
            return "title: \(title), artist: \(artist) duration: \(duration)\n"
        }
    }
}