//
//  TweetViewController.swift
//  TwitterDemo
//
//  Created by Vu Nguyen on 7/23/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit
import AFNetworking

@objc protocol  TweetViewControllerDelegate {
    optional func tweetViewController(tweetViewController: TweetViewController, didPostStatus tweet: Tweet )
}
class TweetViewController: UIViewController{
    
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var tweetText: UITextView!
    @IBOutlet weak var userScreenName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    var user: User?
    let MAX_WORDS = 140
    var delegate: TweetViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        TwitterClient.getSession.currentAccount({ (user: User) in
            self.user = user
            
            self.userName.text = user.name
            self.userScreenName.text = user.screenName
            self.userImage.setImageWithURL(user.profileImageUrl!)
            self.tweetText.delegate = self
        }) { (error: NSError) in
                print("Error: \(error.localizedDescription)")
        }
        userImage.layer.cornerRadius = 8
        countLabel.text = "\(MAX_WORDS)"
        }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweetUpdate(sender: UIBarButtonItem) {
        let statusString = tweetText.text
        TwitterClient.getSession.postTweet(statusString, success: { (newTweetDic: NSDictionary) in
            let newTweet = Tweet(dictionary: newTweetDic)
            self.delegate?.tweetViewController?(self, didPostStatus: newTweet)
            self.dismissViewControllerAnimated(true, completion: nil)
        }) { (error: NSError) in
                print("Return error: \(error.localizedDescription)")
        }
    }
    
    @IBAction func onTweetCancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
extension TweetViewController: UITextViewDelegate{
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let countChars = MAX_WORDS - textView.text.utf16.count
        self.countLabel.text = ("\(countChars)")
        if text.characters.count == 0 { return true }
         return countChars > 0
        
    }
}

