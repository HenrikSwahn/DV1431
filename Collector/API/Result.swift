import Foundation

public enum Result<A> {
    case Error(NSError)
    case Success(A)
    
    /// Creates a result enum
    /// - parameters:
    ///     - error: error (if present)
    ///     - value: value in the container
    init(_ error: NSError?, _ value: A) {
        if let err = error {
            self = .Error(err)
        } else {
            self = .Success(value)
        }
    }
}