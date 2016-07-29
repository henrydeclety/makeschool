//
//  MatchesViewController.swift
//  myApp
//
//  Created by Henry Declety on 7/20/16.
//  Copyright © 2016 Henry Declety. All rights reserved.
//

import UIKit
import Parse

class MatchesViewController: UIViewController {
    
    var matches : [User] = []
    var uIds : [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMatches()
        tableView.dataSource = self
    }

    func getMatches() {
        Like.matches(PFUser.currentUser() as! User).findObjectsInBackgroundWithBlock { (results, error) in
            guard error == nil else {
                print("Error while fetching matches")
                return
            }
            for like in results! {
                let user1 = like["user1"] as! User
                let user2 = like["user2"] as! User
                if (user1.objectId == PFUser.currentUser()!.objectId ){
                    self.matches.append(user2)
                } else {
                    self.matches.append(user1)
                }
                self.uIds.append(user1.objectId! + user2.objectId!)
            }
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func facetime(sender: AnyObject) {
    }

}

extension MatchesViewController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MatchesCell") as! MatchesCell
        cell.displayUser(matches[indexPath.row])
        return cell
    }
    
}
