import Foundation

public protocol APIResource {
    /// Contains the resource which the API protocol will call
    var resource: URL { get set }
}