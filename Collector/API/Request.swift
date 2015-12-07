import Foundation

public struct Request {
    /// Enum container for Request.init
    public enum Source {
        case Value(String)
        case URL(NSURL?)
    }
    
    
    /// Dispatches a request using the Source Enum
    /// - parameters:
    ///     - source: The source data, either String or NSURL
    ///     - completion: A callback function which will be called when the response has arrived
    /// - seealso: Request.Source
    public func dispatch(source: Source, completion: (Result<Response>) -> Void) {
        switch source {
        case .Value(let value):
            if let data = NSData(contentsOfString: value) {
                completion(Result.Success(Response(data: data)))
            } else {
                completion(Result.Error(NSError(domain: "Could not transform string to NSData", code: 0, userInfo: nil)))
            }
            
            
        case .URL(let url) where url != nil:
            let request = NSMutableURLRequest(URL: url!)
                request.setValue("Collector", forHTTPHeaderField: "User-Agent")

            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { d, r, e in
                if let error = e {
                    completion(Result.Error(error))
                } else {
                    if let data = d {
                        let response = Response(data: data, response: r)
                        
                        if let http = response.http {
                            // Response is ok, but is it malformed?
                            if (200..<400).contains(http.statusCode) {
                                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                                    completion(Result(e, response))
                                }
                                return
                            } else {
                                let description = NSHTTPURLResponse.localizedStringForStatusCode(http.statusCode)
                                let httpError = NSError(domain: description, code: http.statusCode, userInfo: nil)
                                completion(Result.Error(httpError))
                                return
                            }
                        }
                    }
                }
                
                completion(Result.Error(NSError(domain: "Could not unwrap data", code: 0, userInfo: nil)))
            }
            
            task.resume()
            
        case .URL(_):
            completion(Result.Error(NSError(domain: "The URL is malformed", code: 0, userInfo: nil)))
        }
    }
}

extension NSData {
    convenience init?(contentsOfString: String) {
        if let data = contentsOfString.dataUsingEncoding(NSUTF8StringEncoding) {
            self.init(data: data)
        }
        
        return nil
    }
}