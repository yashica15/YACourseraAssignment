//
//  FeedItem.swift
//  PhotoFeed
//

import Foundation

class FeedItem :NSObject, NSCoding {

    let title: String
    let imageURL: NSURL
    
    init (title: String, imageURL: NSURL) {
        self.title = title
        self.imageURL = imageURL
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: "itemTitle")
        aCoder.encode(self.imageURL, forKey: "itemURL")
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: "itemTitle")
        aCoder.encode(self.imageURL, forKey: "itemURL")
    }

    required convenience init?(coder aDecoder: NSCoder) {
        
        let storedTitle = aDecoder.decodeObject(forKey: "itemTitle") as? String
        let storedURL = aDecoder.decodeObject(forKey: "itemURL") as? NSURL
        
        guard storedTitle != nil && storedURL != nil else {
            return nil
        }
        self.init(title: storedTitle!, imageURL: storedURL!)
        
        
    }
    
    
}
