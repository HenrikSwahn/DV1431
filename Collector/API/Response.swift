import Foundation

public struct Response {
    /// The data
    public let data: NSData
    
    /// The response
    public var http: NSHTTPURLResponse?
    
    
    /// Creates a response object
    /// - parameters:
    ///     - data: The data contained in this response
    ///     - response: The response, converted to NSHTTPURLResponse (*optional*)
    public init(data: NSData, response: NSURLResponse? = nil) {
        self.data = data
        
        if let res = response {
            self.http = res as? NSHTTPURLResponse
        } else {
            self.http = nil
        }
    }
}