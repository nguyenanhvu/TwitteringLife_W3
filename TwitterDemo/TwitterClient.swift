//
//  TwitterClient.swift
//  TwitterDemo
//
//  Created by Vu Nguyen on 7/21/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
class TwitterClient: BDBOAuth1SessionManager {
    
    
    static let getSession = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com"), consumerKey: "mW5MkRUF1NEwz8RjKVW5IvR6w", consumerSecret: "2jFM74TFG2qovSaw56JCKgbH2ZMK7DO891A5Dpl55rJWzj2YQR")
    var loginSuccess: (()->())?     //indicate login success, set in
    var loginFailure: (NSError -> ())?
    
    func login(success: () -> (), failure: (NSError) -> ()){
        self.loginSuccess = success
        self.loginFailure = failure
            deauthorize()
            fetchRequestTokenWithPath("oauth/request_token", method: "POST", callbackURL: NSURL(string: "TwitteringLife://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
          
            // TODO: redirect to authrization url
            let authUrl = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(authUrl)
            
        }) { (error: NSError!) in
            
           self.loginFailure?(error)
        }
        
    }
    func logout(){
        deauthorize()
        User.currentUser = nil
        NSNotificationCenter.defaultCenter().postNotificationName("TweetUserDidLogOut", object: nil)
    }
    func handleUrl(url: NSURL) {
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        TwitterClient.getSession.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) in
            
            self.loginSuccess?()
            self.currentAccount({ (user: User) in
                User.currentUser = user
                }, failure: { (error: NSError) in
                    print("cannot save current user")
            })
        }) { (error: NSError!) in
            print("\(error.localizedDescription)")
            self.loginFailure?(error)
        }
        
    }
    
    func currentAccount(success: (User)-> (), failure: (NSError)->()){
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                print("\(error.localizedDescription)")
                failure(error)
        })

    }
    func homeTimeline(success: ([Tweet]) -> (),failure: (NSError) -> () ) {
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let dictionaries = response as! [NSDictionary]
            print("begin_dictionary_1010101: \n \(dictionaries)")
            print("End_dictionary_1010101.")
            let tweets =  Tweet.tweetsWithArray(dictionaries)
            success(tweets)
            
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
    }
    func postTweet(statusString: String, success: (NSDictionary)->(), failure:(NSError)->()){
        
        var params = [String : AnyObject]()
        params["status"] = statusString
        POST("1.1/statuses/update.json", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let returnData = response as! NSDictionary
            success(returnData)
        }) { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        }
        
    }
    
    func retweet(id: Int, success: (Tweet)->(), failure: (NSError)-> ()) {
        POST("1.1/statuses/retweet/\(id).json", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            success(Tweet(dictionary: response as! NSDictionary))
        }) { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        }
    }
    
    func unretweet(id: Int, success: (Tweet)->(), failure: (NSError)-> ()) {
        POST("1.1/statuses/unretweet/\(id).json", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            success(Tweet(dictionary: response as! NSDictionary))
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
    }
    
    func favor(id: Int, success: (Tweet)->(), failure: (NSError)-> ()) {
        var params = [String : AnyObject]()
        params["id"] = id
        POST("1.1/favorites/create.json", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            print("\(response)")
            success(Tweet(dictionary: response as! NSDictionary))
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
    }
    
    func defavor(id: Int, success: (Tweet)->(), failure: (NSError)-> ()) {
        var params = [String : AnyObject]()
        params["id"] = id
        POST("1.1/favorites/destroy.json", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            success(Tweet(dictionary: response as! NSDictionary))
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
    }
    
}
