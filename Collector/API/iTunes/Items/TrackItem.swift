import Foundation

public struct iTunesAlbumTrackItem: CustomStringConvertible {
    var title: String
    var artist: String
    var duration: String
    
    public var description: String {
        get {
            return "title: \(title), artist: \(artist) duration: \(duration)\n"
        }
    }
}