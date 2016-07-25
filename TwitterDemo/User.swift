//
//  User.swift
//  TwitterDemo
//
//  Created by Dave Vo on 7/17/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var screenName: String?
    var profileImageUrl: NSURL?
    var tagline: String?
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        tagline = dictionary["description"] as? String
        
        let profileImageURLString = dictionary["profile_image_url_https"] as? String
        if let profileImageURLString = profileImageURLString {
            profileImageUrl = NSURL(string: profileImageURLString)!}
        else {
            print("No Avatar")
        }
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
        if _currentUser == nil {
        let defaults = NSUserDefaults.standardUserDefaults()
            let data = defaults.objectForKey("currentUser") as? NSData
            if data != nil {
            let userDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as? NSDictionary
                _currentUser = User(dictionary: userDictionary!)
            }
        }
        return _currentUser
        }
        set(user) {
        let defaults = NSUserDefaults.standardUserDefaults()
            if user != nil {
            let userData = NSKeyedArchiver.archivedDataWithRootObject(user!.dictionary)
            defaults.setObject(userData, forKey: "currentUser")
               }
            else {
            defaults.setObject(nil, forKey: "currentUser")
            }
            defaults.synchronize()
        }
       
    }
    
}
