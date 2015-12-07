import Foundation

public class URL {
    /// Internal datastructure for the URL computation
    private var components = NSURLComponents()
    
    /// Computes the components and returls a URL.
    /// - returns: NSURL of the components.
    public var url: NSURL? {
        get {
            return components.URL
        }
    }
    
    /// Schemes used in URL.
    /// HTTP: Uses the string "http"
    /// HTTPS: Uses the string "https"
    public enum Scheme {
        case HTTP
        case HTTPS
    }
    
    /// Initializes the object with the default domain
    /// - parameters:
    ///     - host: the path to insert to the URL
    ///     - port: the port number to use (defaults to 80)
    ///     - scheme: the scheme to use (defaults to URL.Scheme.HTTP)
    ///
    /// - seealso: urlDomain
    public init(host: String, port: NSNumber = 80, scheme: URL.Scheme = URL.Scheme.HTTP) {
        self.urlDomain(host, port: port, scheme: scheme)
    }
    
    /// Initialized the object with a path.
    /// - attention: The path ***must*** start with a forward slash character (*/*)
    /// - warning:  The URL will be ***nil*** if no host is set. Make sure that
    ///              you use urlDomain in conjunction with this method
    /// - parameters:
    ///     - path: the path name
    public init(pathed path: String) {
        self.urlPath(pathed: path)
    }
    
    /// Configure the domain of the URL.
    /// - parameters:
    ///     - host: the path to insert to the URL
    ///     - port: the port number to use (defaults to 80)
    ///     - scheme: the scheme to use (defaults to URL.Scheme.HTTP)
    ///
    public func urlDomain(host: String, port: NSNumber = 80, scheme: URL.Scheme = URL.Scheme.HTTP) {
        components.host = host
        if port != 80 {
            components.port = port
        }
        
        switch scheme {
            case .HTTP:
                components.scheme = "http"
            case .HTTPS:
                components.scheme = "https"
        }
    }

    
    /// Inserts a path to a URL that contains several parameters.
    /// - attention: The path ***must*** start with a forward slash character (*/*)
    /// - parameters:
    ///     - pathed: the path to insert to the URL
    ///     - args: variable amount of arguments to append
    /// - seealso: String(format: String, arguments: [CVarArgType])
    ///
    public func urlPath(pathed name: String, args: CVarArgType...) {
        components.path = String(format: name, arguments: args)
    }
    
    /// Defines arguments to an already defined path
    /// - attention: If no path is set, the returned string will be empty
    ///     - parameters:
    ///         - args: variable arguments to append
    /// - seealso: urlPath(format:, arguments:)
    public func urlPath(args arguments: CVarArgType...) {
        if components.path != nil {
            components.path = String(format: components.path!, arguments: arguments)
        }
    }
    

    /// Appends a key-value pair to the querystring of a URL.
    ///
    /// - seealso: NSURLComponents()
    ///
    /// - parameters:
    ///     - field: query field name
    ///     - value: query field value
    public func urlField(named field: String, _ value: String?) {
        let item = NSURLQueryItem(name: field, value: value)
        
        if self.components.queryItems != nil {
            self.components.queryItems?.append(item)
        } else {
            self.components.queryItems = [item]
        }
    }
}
