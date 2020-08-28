//
//  TagsTableViewController.swift
//  PhotoFeed
//

import UIKit
import CoreData


class TagsTableViewController: UITableViewController {

    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?

    override func viewWillAppear(_ animated: Bool) {
        do {
            try self.fetchedResultsController?.performFetch()
        } catch {
            fatalError("tags fetch failed")
        }
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController?.sections!.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController?.sections![section].numberOfObjects ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagCell", for: indexPath as IndexPath)
        let tag = self.fetchedResultsController?.object(at: indexPath as IndexPath) as! Tag
        
        cell.textLabel?.text = tag.title

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImages" {
            let indexPath = self.tableView.indexPathForSelectedRow!
            let destination = segue.destination as! ImageFeedTableViewController
            
            let tag = self.fetchedResultsController?.object(at: indexPath) as! Tag
            if let images = tag.images?.allObjects as? [Image] {
                var feedItems = [FeedItem]()
                for image in images {
                    let imageURL = NSURL(string: image.imageURL ?? "") ?? NSURL()
                    
                    let newFeedItem = FeedItem(title: image.title ?? "(no title)" , imageURL: imageURL)
                    feedItems.append(newFeedItem)
                    
                }
                let feed = Feed(items: feedItems, sourceURL: NSURL())
                destination.feed = feed
            }
        }
    }

}
