//
//  SearchAPI.swift
//  Collector
//
//  Created by Dino Opijac on 07/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

class SearchAPI {
    private let context: ViewContextEnum
    internal var delegate: SearchAPIDelegate?
    private var movieSearchResults: [TMDbSearchItem]?
    private var musicSearchResults: [ItunesAlbumItem]?
    
    private struct Storyboard {
        static var Movie = ""
        static var Music = ""
    }
    
    internal init(context: ViewContextEnum, reuseIdentifierForMovie: String, reuseIdentifierForMusic: String) {
        self.context = context
        self.delegate = nil
        
        Storyboard.Movie = reuseIdentifierForMovie
        Storyboard.Music = reuseIdentifierForMusic
    }
    
    internal func perform(forTerm: String?) {
        // If we have no delegates or terms do nothing
        if self.delegate != nil && forTerm != nil {
            switch context {
                case .Movie:
                    let tmdb = TMDb(resource: TMDbSearchResource(forTerm: forTerm!))
                        tmdb.request(willSearch)
                case .Music:
                    let itunes = Itunes(resource: ItunesSearchResource(forTerm: forTerm!))
                        itunes.request(willSearch)
            default: break
            }
        }
    }
    
    private func willSearch(result: Result<Response>) -> Void {
        switch result {
        case .Error(let e):
            self.delegate?.searchAPI(didFail: e)
        case .Success(let response):
            switch self.context {
            case .Movie:
                self.movieSearchResults = TMDb.parseSearch(JSON(response.data))
                self.delegate?.searchAPI(self.movieSearchResults!.count ?? 0)
            case .Music:
                self.musicSearchResults = Itunes.parseSearch(JSON(response.data))
                self.delegate?.searchAPI(self.musicSearchResults?.count ?? 0)
            default: break
            }
        }
    }
    
    internal func count() -> Int {
        switch self.context {
        case .Movie where self.movieSearchResults != nil:
            return (self.movieSearchResults?.count)!
        case .Music where self.musicSearchResults != nil:
            return (self.musicSearchResults?.count)!
        default:
            return 0
        }
    }
    
    internal func cellForIndexPath(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        switch self.context {
        case .Movie where self.movieSearchResults != nil:
            if let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.Movie, forIndexPath: indexPath) as? SearchMovieEntryTableViewCell {
                cell.model = self.movieSearchResults![indexPath.row]
                return cell
            }
            
        case .Music where self.musicSearchResults != nil:
            if let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.Music, forIndexPath: indexPath) as? SearchMusicEntryTableViewCell {
                cell.model = self.musicSearchResults![indexPath.row]
                return cell
            }
        default: break
            
        }
        
        // If we end up here. Something is wrong.
        return UITableViewCell()
    }
    
    func cellForRowAtIndexPath(tableView: UITableView, indexPath: NSIndexPath) -> SearchMovieEntryTableViewCell? {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if let cellAtPath = cell as? SearchMovieEntryTableViewCell {
                return cellAtPath
            }
        }
        
        return nil
    }
    
    func cellForRowAtIndexPath(tableView: UITableView, indexPath: NSIndexPath) -> SearchMusicEntryTableViewCell? {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if let cellAtPath = cell as? SearchMusicEntryTableViewCell {
                return cellAtPath
            }
        }
        
        return nil
    }
    
    internal func empty() {
        self.movieSearchResults = nil
        self.musicSearchResults = nil
    }
    
    func getForSelectedAlbumIndexPath(indexPath: NSIndexPath) -> ItunesAlbumItem {
        return self.musicSearchResults![indexPath.row]
    }
    
    func getForSelectedMovieIndexPath(indexPath: NSIndexPath) -> TMDbSearchItem {
        return self.movieSearchResults![indexPath.row]
    }
}