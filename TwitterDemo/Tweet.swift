//
//  Tweet.swift
//  TwitterDemo
//
//  Created by Dave Vo on 7/17/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var timeSinceCreated: String?
    var entities: NSDictionary?
    var statusId: Int?
    var favorited: Bool?
    var retweeted: Bool?
    
    var retweetedStatus: Tweet?
    
    var retweetCount = 0
    var favCount = 0
    
    
    init(dictionary: NSDictionary) {
        
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int)!
        favCount = (dictionary["favorite_count"] as? Int)!
        entities = (dictionary["entities"] as? NSDictionary)
        
        favorited = (dictionary["favorited"] as? Bool)
        retweeted = (dictionary["retweeted"] as? Bool)
        statusId = (dictionary["id"] as? Int)
        
        if let object = (dictionary["retweeted_status"] as? NSDictionary ) {
            retweetedStatus = Tweet(dictionary: object)
        }
        
        
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        
        let elapsedTime = NSDate().timeIntervalSinceDate(createdAt!)
        if elapsedTime < 60 {
            timeSinceCreated = String(Int(elapsedTime)) + "s"
        } else if elapsedTime < 3600 {
            timeSinceCreated = String(Int(elapsedTime / 60)) + "m"
        } else if elapsedTime < 24*3600 {
            timeSinceCreated = String(Int(elapsedTime / 60 / 60)) + "h"
        } else {
            timeSinceCreated = String(Int(elapsedTime / 60 / 60 / 24)) + "d"
        }
        
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dict in array {
            tweets.append(Tweet(dictionary: dict))
        }
        return tweets
    }
}
