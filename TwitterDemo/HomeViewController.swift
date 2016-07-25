//
//  HomeViewController.swift
//  TwitterDemo
//
//  Created by Dave Vo on 7/17/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit
import AFNetworking
class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]!
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        loadHomeTimeline()
        
//        TwitterClient.getSession.homeTimeline({ (tweets: [Tweet]) in
//            self.tweets = tweets
//            self.tableView.reloadData()
//        }) { (error: NSError) in
//                print("\(error.localizedDescription)")
//        }
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl)
    {
        loadHomeTimeline()
        refreshControl.endRefreshing()
    }
    
    func loadHomeTimeline(){
        TwitterClient.getSession.homeTimeline({ (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }) { (error: NSError) in
            print("\(error.localizedDescription)")
        }
    }
    
    @IBAction func onLogOutButton(sender: UIBarButtonItem) {
        TwitterClient.getSession.logout()
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
         let navigationVC = segue.destinationViewController as! UINavigationController
        if segue.identifier == "segueHomeToTweet" {
           
            let nextVC =  navigationVC.topViewController as! TweetViewController
            nextVC.delegate = self
        }
        
        if segue.identifier == "TweetSegue" {
            
            let VC = navigationVC.topViewController as! DetailViewController
            let ip = tableView.indexPathForSelectedRow
            //VC.tweet = tweets[ip!.row]
            let tweetSelected = self.tweets[ip!.row]
            VC.tweet = tweetSelected
            VC.delegate = self
            
        }

     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
    
    
}
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets.count}
        else {
            return 0 }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("TweetSegue", sender: self)
        
    }
    
}
extension HomeViewController: TweetViewControllerDelegate{
    func tweetViewController(tweetViewController: TweetViewController, didPostStatus tweet: Tweet) {
        self.tweets.insert(tweet, atIndex: 0)
        
        tableView.reloadData()
    }
}

extension HomeViewController: DetailViewControllerDelegate{
    func detailViewController(detailViewController: DetailViewController, didUpdatedTweet tweet: Tweet) {
        let ip = tableView.indexPathForSelectedRow
        tweets[ip!.row].favorited = tweet.favorited
        tweets[ip!.row].retweeted = tweet.retweeted
        tableView.reloadData()
    }
}
