import Foundation

public protocol API {
    /// Creates a instance of the API
    /// - parameters:
    ///     - api: APIResource instance which contains the necessary resource data
    ///     - completion: Callback when the resource has been fetched
    init(_ api: APIResource, completion: (Result<Response>) -> Void)
}
