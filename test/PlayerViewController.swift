//
//  PlayerViewController.swift
//  myApp
//
//  Created by Henry on 7/14/16.
//  Copyright © 2016 Henry Declety. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import Darwin
import Parse


class PlayerViewController: UIViewController {
    
    var videoID: String!
    let maxTimeInterval = 30
    @IBOutlet weak var start: TimePickerView!
    @IBOutlet weak var end: TimePickerView!
    @IBOutlet weak var waitingView: UIActivityIndicatorView!
    @IBOutlet weak var playerView: YTPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        waitingForInfo()
        playerView.loadWithVideoId(videoID)
        start.delegate = self
        end.delegate = self
        start.dataSource = self
        end.dataSource = self
        playerView.delegate = self
    }
    
    func minutes() -> Int {
        return Int(floor(playerView.duration()/60))
    }
    
    func waitingForInfo() {
        waitingView.startAnimating()
        start.hidden = true
        end.hidden = true
    }
    
    func infoReceived() {
        waitingView.stopAnimating()
        waitingView.hidden = true
        start.hidden = false
        end.hidden = false
    }
    
    func seconds() -> Int {
        return Int(playerView.duration()) - minutes() * 60
    }
    
    func duration() -> Int {
        if (end.minutes() == 0){
            return end.seconds() + 1
        } else {
            return 60 - start.seconds() + end.seconds()
        }
    }
    
    @IBAction func save(sender: AnyObject) {
        let post = PFObject(className : "Post")
        post["videoID"] = videoID
        post["user"] = PFUser.currentUser()
        post["start"] = start.totalInSec()
        post["end"] = duration() + start.totalInSec()
        post["duration"] = duration()
        post.saveInBackgroundWithBlock { (success: Bool, error: NSError?) in
            if (success){
                print("succefully uploaded, im a boss")
            }
        }
    }
}

extension PlayerViewController : UIPickerViewDataSource {

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 0){
            if (component == 0){
                return minutes()
            } else {
                if (start.minutes() == minutes()) {return seconds()}
                else {return 60}
            }
        } else {
            if (component == 0){
                if (start.seconds() >= 60 - maxTimeInterval && start.minutes() < minutes()) {
                    return 2
                } else {
                    return 1
                }
            } else {
                if (end.minutes() == 0){
                    return min(60 - (start.seconds()+1),maxTimeInterval)
                } else {
                    return min((start.seconds()+1) - 30, maxTimeInterval)
                }
            }
        }
    }


}


extension PlayerViewController : UIPickerViewDelegate {
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 0){
            return String(row)
        } else {
            if (component == 0){
                return String(start.minutes() + row)
            } else {
                if (end.minutes() == 0){
                    return String(start.seconds() + row + 1)
                } else {
                    return String(row)
                }
            }
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        start.reloadAllComponents()
        end.reloadAllComponents()
    }

}


extension PlayerViewController : YTPlayerViewDelegate {

    func playerViewDidBecomeReady(playerView: YTPlayerView) {
        infoReceived()
        start.reloadAllComponents()
        end.reloadAllComponents()
    }
    
}
















