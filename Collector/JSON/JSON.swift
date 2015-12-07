import Foundation

/*
JSON Parser
*/
public enum JSON {
    case JSArray(Array<JSON>)
    case JSString(String)
    case JSNumber(Double)
    case JSObject(Dictionary<String, JSON>)
    case JSIllegal
    case JSNull
    
    public init(_ value: String?) {
        self = JSString(value!) ?? .JSIllegal
    }
    
    public init(_ value: Double?) {
        self = JSNumber(value!) ?? .JSIllegal
    }
    
    public init(_ value: Int?) {
        self = JSNumber(Double(value!)) ?? .JSIllegal
    }
    
    public init(_ value: Dictionary<String, JSON>?) {
        self = JSObject(value!) ?? .JSIllegal
    }
    
    public init(_ value: Array<JSON>?) {
        self = JSArray(value!) ?? .JSIllegal
    }
    
    public init(_ value: NSData) {
        do {
            self = try JSON.decode(value)
        } catch (_) {
            self = .JSIllegal
        }
    }
    
    public init(_ value: AnyObject?) {
        if let undefValue: AnyObject = value {
            switch undefValue {
            case let arrayValue as NSArray:
                self = .JSArray(arrayValue.map({ JSON($0) }))
                
            case let dictionaryValue as NSDictionary:
                var dictionary: Dictionary<String, JSON> = [:]
                for(k, v): (AnyObject, AnyObject) in dictionaryValue {
                    if let key = k as? String {
                        dictionary[key] = JSON(v)
                    } else {
                        self = .JSIllegal
                        return
                    }
                }
                self = .JSObject(dictionary)
                
            case let stringValue as NSString:
                self = .JSString(stringValue as String)
                
            case let numberValue as NSNumber:
                self = .JSNumber(numberValue.doubleValue)
                
            case let arbitraryData as NSData:
                do {
                    self = try JSON.decode(arbitraryData)
                } catch (_) {
                    self = .JSIllegal
                }
                
            case _ as NSNull:
                self = .JSNull
                
            default:
                self = .JSIllegal
            }
        } else {
            self = .JSIllegal
        }
    }
    
    public static var ReadingOptions: NSJSONReadingOptions = NSJSONReadingOptions.MutableContainers
    
    public static func decode(data: NSData) throws -> JSON {
        return JSON(try NSJSONSerialization.JSONObjectWithData(data, options: JSON.ReadingOptions))
    }
    
    public static func decode(data: String) throws -> JSON {
        return JSON(try NSJSONSerialization.JSONObjectWithData(data.dataUsingEncoding(NSUTF8StringEncoding)!, options: JSON.ReadingOptions))
    }
    
    public var string: String? {
        switch self {
        case .JSString(let value):
            return value
        default:
            return nil
        }
    }
    
    public var int: Int? {
        switch self {
        case .JSNumber(let intValue):
            return Int(intValue)
        default:
            return nil
        }
    }
    
    public var double: Double? {
        switch self {
        case .JSNumber(let doubleValue):
            return doubleValue
        default:
            return nil
        }
    }
    
    public var array: Array<JSON>? {
        switch self {
        case .JSArray(let arrayValue):
            return arrayValue
        default:
            return nil
        }
    }
    
    public var object: Dictionary<String, JSON>? {
        switch self {
        case .JSObject(let dictionaryValue):
            return dictionaryValue
            
        default:
            return nil
        }
    }
    
    public subscript(index: Int) -> JSON {
        switch self {
        case .JSArray(let array) where array.count > index:
            return array[index]
        default:
            return .JSIllegal
        }
    }
    
    public subscript(key: String) -> JSON {
        switch self {
        case .JSObject(let dictionary):
            return dictionary[key] ?? .JSIllegal
            
        default:
            return .JSIllegal
        }
    }
}