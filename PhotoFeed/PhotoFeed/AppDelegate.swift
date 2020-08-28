//
//  AppDelegate.swift
//  PhotoFeed
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var dataController: DataController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UserDefaults.standard.register(defaults: ["PhotoFeedURLString": "https://api.flickr.com/services/feeds/photos_public.gne?tags=kitten&format=json&nojsoncallback=1"])
        self.dataController = DataController()

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        let urlString = UserDefaults.standard.string(forKey: "PhotoFeedURLString")
        print(urlString as Any)
        
        
        guard let foundURLString = urlString else {
            return
        }
        
        if let url = NSURL(string: foundURLString) {
            self.loadOrUpdateFeed(url: url, completion: { (feed) -> Void in
                let navController = application.windows[0].rootViewController as? UINavigationController
                let viewController = navController?.viewControllers[0] as? ImageFeedTableViewController
                viewController?.feed = feed
            })
        }
    }
    

    func updateFeed(url: NSURL, completion: @escaping (_ feed: Feed?) -> Void) {
        let request = NSURLRequest(url: url as URL)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if error == nil && data != nil {
                let feed = Feed(data: data! as NSData, sourceURL: url)
                
                if let goodFeed = feed {
                    if self.saveFeed(feed: goodFeed) {
                        UserDefaults.standard.set(NSDate(), forKey: "lastUpdate")
                    }
                }
                
                print("loaded Remote feed!")
                
                OperationQueue.main.addOperation({ () -> Void in
                    completion(feed)
                })
            }

        }
        
        task.resume()
    }
    
    func feedFilePath() -> String {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let filePath = paths[0].appendingPathComponent("feedFile.plist")
        return filePath.path
    }
    
    func saveFeed(feed: Feed) -> Bool {
        let success = NSKeyedArchiver.archiveRootObject(feed, toFile: feedFilePath())
        assert(success, "failed to write archive")
        return success
    }
    
    func readFeed(completion: (_ feed: Feed?) -> Void) {
        let path = feedFilePath()
        let unarchivedObject = NSKeyedUnarchiver.unarchiveObject(withFile: path)
        completion(unarchivedObject as? Feed)
    }

    
    func loadOrUpdateFeed(url: NSURL, completion: @escaping (_ feed: Feed?) -> Void) {

        let lastUpdatedSetting = UserDefaults.standard.object(forKey: "lastUpdate") as? NSDate
        
        var shouldUpdate = true
        if let lastUpdated = lastUpdatedSetting, NSDate().timeIntervalSince(lastUpdated as Date) < 20 {
            shouldUpdate = false
        }
        if shouldUpdate {
            self.updateFeed(url: url, completion: completion)
        } else {
            self.readFeed { (feed) -> Void in
                if let foundSavedFeed = feed, foundSavedFeed.sourceURL.absoluteString == url.absoluteString {
                    print("loaded saved feed!")
                    OperationQueue.main.addOperation({ () -> Void in
                        completion(foundSavedFeed)
                    })
                } else {
                    self.updateFeed(url: url, completion: completion)
                }
                
                
            }
        }
        
        
        
    }

}

