//
//  TweetCell.swift
//  TwitterDemo
//
//  Created by Vu Nguyen on 7/22/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {


    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var favorImage: UIImageView!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var replyImage: UIImageView!
    
    @IBOutlet weak var retweetedIcon: UIImageView!
    
    @IBOutlet weak var retweetedIconH: NSLayoutConstraint!
    @IBOutlet weak var retweetedIconW: NSLayoutConstraint!
    
    
    @IBOutlet weak var retweetedUser: UILabel!
    
    var tweet: Tweet!{
        didSet{
            
            
            print((tweet.user?.name ?? "anonymous") + "Retweeted")
            if tweet.retweetedStatus != nil {
                retweetedUser.text =  (tweet.user?.name ?? "anonymous") + " Retweeted"
                retweetedUser.alpha = 1
                retweetedIconH.constant = 15
                retweetedIconW.constant = 15
            } else {
                retweetedUser.alpha = 0
                retweetedIconH.constant = 0
                retweetedIconW.constant = 0
            }
            
            
            //get the original tweet
            let originalTweet = tweet.retweetedStatus ?? tweet
            
            timestampLabel.text = originalTweet!.timeSinceCreated
            tweetLabel.text = originalTweet!.text
            
            if originalTweet?.favorited == true {
                favorImage.image = UIImage(named: "LikeOn")
            } else {
                favorImage.image = UIImage(named: "LikeOff")
            }
            
            if originalTweet?.retweeted == true {
                retweetImage.image = UIImage(named: "RetweetOn")
            } else {
                retweetImage.image = UIImage(named: "RetweetOff")
            }
            
            
            if let user = originalTweet!.user {
                nameLabel.text = user.name
                idLabel.text = "@" + user.screenName!
                avatarImage.setImageWithURL(user.profileImageUrl!)
            }
            else {
                nameLabel.text = "anonymous"
                idLabel.text = "@anonymous"
                avatarImage.image = UIImage(named: "NoUserImage")
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarImage.layer.cornerRadius = 8
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
