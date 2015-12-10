import Foundation

protocol API {
    @available(*, deprecated)
    var request: Request { get set }
    var resource: APIResource? { get set }
    
    init(_ api: APIResource, completion: (Result<Response>) -> Void)
    func request(completion: (Result<Response>) -> Void)
}

extension API {
    /** Remove **/
    func request(completion: (Result<Response>) -> Void) {
        preconditionFailure("This method must be overridden")
    }
    
    internal static func dateToYear(date: String?) -> Int {
        return 1970
    }
}
