import Foundation

public class API {
    /// Creates a instance of the API
    /// - parameters:
    ///     - api: APIResource instance which contains the necessary resource data
    ///     - completion: Callback when the resource has been fetched
    required public init(_ api: APIResource, completion: (Result<Response>) -> Void) {}
    
    
    /// Returns the year from a date
    /// parameters:
    ///     - date: A datestring in Itunes format.
    public static func dateToYear(date: String?) -> Int {
        if let string = date {
            if string.characters.count > 4 {
                return Int(string.substringToIndex(string.startIndex.advancedBy(4)))!
            } else {
                return Int(string)!
            }
        }
        
        return 1970
    }
}
