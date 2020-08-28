//
//  Feed.swift
//  PhotoFeed
//

import Foundation



func fixJsonData (data: NSData) -> NSData {
    var dataString = String(data: data as Data, encoding: String.Encoding.utf8)!
    dataString = dataString.replacingOccurrences(of: "\\'", with: "'")
    return dataString.data(using: String.Encoding.utf8)! as NSData
    
}


class Feed :NSObject, NSCoding {

    let items: [FeedItem]
    let sourceURL: NSURL
    
    init (items newItems: [FeedItem], sourceURL newURL: NSURL) {
        self.items = newItems
        self.sourceURL = newURL
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(self.items, forKey: "feedItems")
        aCoder.encode(self.sourceURL, forKey: "feedSourceURL")
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.items, forKey: "feedItems")
        aCoder.encode(self.sourceURL, forKey: "feedSourceURL")
    }

    required convenience init?(coder aDecoder: NSCoder) {
        
        let storedItems = aDecoder.decodeObject(forKey: "feedItems") as? [FeedItem]
        let storedURL = aDecoder.decodeObject(forKey: "feedSourceURL") as? NSURL
        
        guard storedItems != nil && storedURL != nil  else {
            return nil
        }
        self.init(items: storedItems!, sourceURL: storedURL! )
        
    }
    
    convenience init? (data: NSData, sourceURL url: NSURL) {
        
        var newItems = [FeedItem]()
        
        let fixedData = fixJsonData(data: data)
        
        var jsonObject: Dictionary<String, AnyObject>?
        
        do {
            jsonObject = try JSONSerialization.jsonObject(with: fixedData as Data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? Dictionary<String,AnyObject>
        } catch {
            
        }
        
        guard let feedRoot = jsonObject else {
            return nil
        }
        
        guard let items = feedRoot["items"] as? Array<AnyObject>  else {
            return nil
        }
        
        
        for item in items {
            
            guard let itemDict = item as? Dictionary<String,AnyObject> else {
                continue
            }
            guard let media = itemDict["media"] as? Dictionary<String, AnyObject> else {
                continue
            }
            
            guard let urlString = media["m"] as? String else {
                continue
            }
            
            guard let url = NSURL(string: urlString) else {
                continue
            }
            
            let title = itemDict["title"] as? String
            
            newItems.append(FeedItem(title: title ?? "(no title)", imageURL: url))
            
        }
        
        self.init(items: newItems, sourceURL: url)
    }
    
}
