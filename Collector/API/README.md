### Usage

When writing a new Resource or request to a API. Use the Playground in Xcode. The code below is all you need
to send a request to a API and retrieve a result.

We begin by writing a function that will print out all our messages to the console. You will probably not use
this when importing to iOS

```
// This function only prints what was resolved in a response
func whenDone(then: (JSON) -> Any?) -> (Result<Response>) -> Void {
    return { result in
        switch result {
            case .Error(let err):
                print(err)
        case .Success(let response):
            let a = then(JSON(response.data))
            print(a)
        }
    }
}
```swift

The next step is to define the resources:

```
// Creating of API resources
let getMovieOnTMDb    = TMDbMovieResource(id: 150)
let findMovieOnTMDb   = TMDbSearchResource(forTerm: "The Movie")
let getAlbumOnLastFM  = LastFMAlbumResource(id: "25")
let findAlbumOnLastFM = LastFMSearchResource(forTerm: "The Wall")
let getAlbumOnItunes  = ItunesAlbumResource(id: "100")
let findAlbumOnItunes = ItunesSearchResource(forTerm: "test term")
```swift

Now, all that's left is to send the requests and wait for the response. Errors will be handled in the Error case
and data will be handled in Success case. Each TMDb, Itunes and LastFM instance appends the required values to the URL (such as API keys and standard query strings). The example below shows the different standard requests:
```
// Finds a specific album on iTunes with the given resource
Itunes(getAlbumOnItunes, completion: whenDone(Itunes.parseAlbum))

// Finds a album on iTunes with the given resource
Itunes(findAlbumOnItunes, completion: whenDone(Itunes.parseSearch))

// Retrieves a specific album on LastFM with the given resource
LastFM(getAlbumOnLastFM, completion: whenDone(LastFM.parseAlbum))

// Finds a album on LastFM with the given resource
LastFM(findAlbumOnLastFM, completion: whenDone(LastFM.parseSearch))

// Retrieves a specific movie on TMDb with the given resource
TMDb(getMovieOnTMDb, completion: whenDone(TMDb.parseMovie))

// Finds a movie on TMDb with the given resource
TMDb(findMovieOnTMDb, completion: whenDone(TMDb.parseSearch))
```swift

### Creating custom resources
The LastFM, TMDb and iTunes APIs are not limited to the resources above. You can write your own by conforming to the APIResource protocol. In order to conform: 

* Create a URL resource. If using `path` such as the one shown below, it must start with "/"
* Implement a initializer to enable custom parameters.
```
public struct MyResource: APIResource {
    public var resource = URL(pathed: "/path/to/something")

    public init(doSomething: String) {
        resource.urlField(named: "doingSomething", doSomething)
    }
}
```swift

The resource can be used by all APIs specified above, here's a iTunes example:
```
let myCustomResource = MyResource(doSomething: "jumping")
iTunes(myCustomResource) { result in
    switch result {
        case .Error(let e):
            // Handle the error
            print(e)
        case .Success(let response):
            // Do something with the response
            print(response)
    }
}
```swift

The above example will send a reqest to `https://itunes.apple.com/path/to/something?doingSomething=jumping`