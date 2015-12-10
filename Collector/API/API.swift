import Foundation

protocol API {
    var request: Request? { get set }
    var resource: APIResource? { get set }
    
    init(resource: APIResource)
    func request(completion: (Result<Response>) -> Void)
}

extension API {
    internal static func dateToYear(date: String?) -> Int {
        var year: Int?

        if let string = date {
            if string.characters.count > 4 {
                year = Int(string.substringToIndex(string.startIndex.advancedBy(4)))
            } else {
                year = Int(string)
            }
        }
        
        if year != nil {
            return year!
        }
        
        return 1970
    }
}
