//
//  DetailViewController.swift
//  TwitterDemo
//
//  Created by Vu Nguyen on 7/24/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit

@objc protocol DetailViewControllerDelegate{
    optional func detailViewController(detailViewController: DetailViewController, didUpdatedTweet tweet: Tweet)
}

class DetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var favoritiesLabel: UILabel!
    @IBOutlet weak var retweetsNumLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var favorButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var retweetedbyLabel: UILabel!
    @IBOutlet weak var retweetedLogoH: NSLayoutConstraint!
    
    
    
    var name: String?
    var screenName: String?
    var userImageURL: NSURL?
    var tweetContent: String?
    var timeStamp: NSDate?
    var retweetsNum: Int?
    var favoritiesNum: Int?
    var favor: Bool?
    var retweeted: Bool?
    var tweetID: Int?
    
    var delegate: DetailViewControllerDelegate?
    
    
    var tweet: Tweet!{
        didSet{
            
            let originalTweet = tweet.retweetedStatus ?? tweet
            
            tweetContent = originalTweet!.text
            retweetsNum = originalTweet!.retweetCount
            favoritiesNum = originalTweet!.favCount
            timeStamp = originalTweet!.createdAt!
            favor = originalTweet!.favorited!
            retweeted =  originalTweet!.retweeted!
            tweetID = originalTweet!.statusId
            if let user = originalTweet!.user {
                name = user.name
                screenName = "@" + user.screenName!
                userImageURL = user.profileImageUrl
            }
            else {
                name = "anonymous"
                screenName = "@anonymous"
                userImageURL = nil
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM/YYY HH:mm a"
        //print()

        
        nameLabel.text = name!
        screenNameLabel.text = screenName!
        contentLabel.text = tweetContent!
        timeStampLabel.text = formatter.stringFromDate(timeStamp!)
        
        retweetsNumLabel.text = "\(retweetsNum!)"
        favoritiesLabel.text = "\(favoritiesNum!)"
        
        if tweet.retweetedStatus != nil {
            retweetedbyLabel.text = (tweet.user?.name)! + " retweeted"
            retweetedLogoH.constant = 15
            retweetedbyLabel.alpha = 1
        }
        else {
            retweetedLogoH.constant = 0
            retweetedbyLabel.alpha = 0
        }

        
        if favor! {
            favorButton.setImage(UIImage(named: "LikeOn"), forState: .Normal)}
        else {
            favorButton.setImage(UIImage(named: "LikeOff"), forState: .Normal)}
        
        if retweeted! {
            retweetButton.setImage(UIImage(named: "RetweetOn"), forState: .Normal)}
        else {
            retweetButton.setImage(UIImage(named: "RetweetOff"), forState: .Normal)}

        if userImageURL != nil {
            userImage.setImageWithURL(userImageURL!)
        } else {
            userImage.image = UIImage(named: "NoUserImage")
        }
        
        userImage.layer.cornerRadius = 8
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onHomePressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onReplyPressed(sender: UIBarButtonItem) {
        
        if tweet.favorited != favor {
            if favor! {
                    TwitterClient.getSession.favor(tweetID!, success: { (tweet: Tweet) in
                    print("\(tweet.favorited)")
                    }, failure: { (error: NSError) in
                        print("\(error.localizedDescription)") })
            }
            else {
                TwitterClient.getSession.defavor(tweetID!, success: { (tweet: Tweet) in
                    print("\(tweet.favorited)")
                    }, failure: { (error: NSError) in
                        print("\(error.localizedDescription)") })
            
            }
        }
        
        if tweet.retweeted != retweeted {
            if retweeted! {
                print("\(tweetID)")
                TwitterClient.getSession.retweet(tweetID!, success: { (tweet: Tweet) in
                    print("\(tweet.retweeted)")
                    }, failure: { (error: NSError) in
                        print("\(error.localizedDescription)") })
            }
            else {
                TwitterClient.getSession.unretweet(tweetID!, success: { (tweet: Tweet) in
                    print("\(tweet.retweeted)")
                    }, failure: { (error: NSError) in
                        print("\(error.localizedDescription)") })
            }
            
        }
        tweet.favorited = favor
        tweet.retweeted = retweeted
        delegate?.detailViewController!(self, didUpdatedTweet: tweet)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onFavorPressed(sender: UIButton) {
        if favor! {
            favor = false
            favorButton.setImage(UIImage(named: "LikeOff"), forState: .Normal)
            self.favoritiesNum = self.favoritiesNum! - 1
            self.favoritiesLabel.text = "\(self.favoritiesNum!)" }
    
        else {
            favor = true
            favorButton.setImage(UIImage(named: "LikeOn"), forState: .Normal)
            self.favoritiesNum = self.favoritiesNum! + 1
            self.favoritiesLabel.text = "\(self.favoritiesNum!)"
        }
    }
    
    @IBAction func onRetweetPressed(sender: UIButton) {
        if retweeted! {
            retweeted = false
            retweetButton.setImage(UIImage(named: "RetweetOff"), forState: .Normal)
            self.retweetsNum = self.retweetsNum! - 1
            self.retweetsNumLabel.text = "\(self.retweetsNum!)"
        }
        else {
            retweeted = true
            retweetButton.setImage(UIImage(named: "RetweetOn"), forState: .Normal)
            self.retweetsNum = self.retweetsNum! + 1
            self.retweetsNumLabel.text = "\(self.retweetsNum!)"
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    */

}