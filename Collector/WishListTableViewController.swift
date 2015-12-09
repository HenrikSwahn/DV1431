//
//  WishlistTableViewController.swift
//  Collector
//
//  Created by Dino Opijac on 09/12/15.
//  Copyright © 2015 Dino Opijac. All rights reserved.
//

import UIKit

enum MediaType: String {
    case Movie  = "Movie"
    case Music  = "Music"
    case Game   = "Game"
    case Book   = "Book"
}

struct WishListItem {
    // ID for the item in CoreData?
    var id: Int
    
    // ID for the item in the API
    var aid: String
    
    // Type of media
    var type: MediaType
    
    // The cover art for the media
    var imageData: NSData?
    
    // Title for the item
    // Movie: This is should contain the title of the movie
    // Album: This is should contain the title of the album
    // Game: This should contain then name of the game
    // Book: This should contain the title of the book
    var title: String
    
    // Detail
    // Movie: This should be empty (optional)
    // Album: This should contain the artist
    // Game: This should be empty
    // Book: This should contain author
    var detail: String?
}

class WishListTableViewController: UITableViewController {
    private var model = [
        WishListItem(id: 0, aid: "ID from API", type: .Movie, imageData: nil, title: "A Movie", detail: nil),
        WishListItem(id: 0, aid: "ID from API", type: .Music, imageData: nil, title: "A Album", detail: "Artist"),
        WishListItem(id: 0, aid: "ID from API", type: .Game,  imageData: nil, title: "A Game",  detail: nil),
        WishListItem(id: 0, aid: "ID from API", type: .Book,  imageData: nil, title: "A Book",  detail: "Author")
    ]
    
    struct Storyboard {
        static let RectReuseIdentifier  = "WishListRectangle"
        static let BoxReuseIdentifier   = "WishListBox"
    }
    
    enum WishAction {
        case Insert
        case Delete
    }
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = model[indexPath.row]
        
        switch item.type {
        case .Movie, .Game:
            if let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.RectReuseIdentifier, forIndexPath: indexPath) as? WishListRectangleTableViewCell {
                cell.wish = item
                return cell
            }
            
        case .Music, .Book:
            if let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.BoxReuseIdentifier, forIndexPath: indexPath) as? WishListBoxTableViewCell {
                cell.wish = item
                return cell
            }
        }
        
        return UITableViewCell()
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let insert = UITableViewRowAction(style: .Normal,  title: "Add",      handler: wishAction(action: .Insert))
        let delete = UITableViewRowAction(style: .Default, title: "Delete",   handler: wishAction(action: .Delete))

        return [insert, delete]
    }
    
    
    // MARK: - WishActions
    
    // Creates two default alert actions, "Yes" and "No". You only have to specify the ActionStyle for the "Yes" instance
    func defaultAlertActions(style: UIAlertActionStyle, handler: ((UIAlertAction) -> Void)?) -> [UIAlertAction] {
        return [
            UIAlertAction(title: "Yes",    style: UIAlertActionStyle.Default, handler: handler),
            UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        ]
    }
    
    // Returns a new instance of a desired controller with the proper text
    func wishAction(controller type: WishAction) -> UIAlertController {
        switch type {
        case .Delete: return UIAlertController(title: "Delete", message: "Would you like to remove this item from the wish list?",  preferredStyle: .ActionSheet)
        case .Insert: return UIAlertController(title: "Insert", message: "Would you like to insert this item to the main library?", preferredStyle: .ActionSheet)
        }
    }
    
    // Performs the actions
    func wishAction(action sheet: WishAction) -> (action: UITableViewRowAction, indexPath: NSIndexPath) -> Void {
        return { [unowned self] (action, indexPath) in
            let controller: UIAlertController = self.wishAction(controller: sheet)
            
            switch sheet {
            case .Insert:
                // Insert this item to the main library
                controller.addActions(self.defaultAlertActions(.Destructive) { _ in
                    // Call the REST API with the given ID (self.model[indexPath.row].aid)
                    // When done, add it to the library and finally:
                    self.tableView.setEditing(false, animated: true)
                })
                
            case .Delete:
                // Delete this item from the wish list
                controller.addActions(self.defaultAlertActions(.Default) { [unowned self] _ in
                    // Here is where you should do Core Data related things
                    //
                    // Edit this code:
                    // if (item was removed from Core Data) {
                    self.model.removeAtIndex(indexPath.row)
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    // } else {
                })
            }
            
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension UIAlertController {
    func addActions(actions: [UIAlertAction]) {
        actions.forEach() { self.addAction($0) }
    }
}
