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


public class PlayerViewController: UIViewController {
    
    var post : Post!
    var maxTimeInterval : Int!
    @IBOutlet weak var nameSPT: UILabel!
    @IBOutlet weak var artistSPT: UILabel!
    @IBOutlet weak var timeSTP: UILabel!
    @IBOutlet weak var start: TimePickerView!
    @IBOutlet weak var end: TimePickerView!
    @IBOutlet weak var waitingView: UIActivityIndicatorView!
    @IBOutlet weak var ytPlayerView: YTPlayerView!
    @IBOutlet weak var sptPlayerView: UIView!
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        if post.isYoutube() {
            setAsYT()
        } else {
            setAsSPT()
        }
    }
    
    func setAsYT() {
        waitingForInfo()
        sptPlayerView.hidden = true
        ytPlayerView.loadWithVideoId(post.videoID!, playerVars: Constants.ytParams() as [NSObject : AnyObject])
        ytPlayerView.delegate = self
    }
    
    func setAsSPT() {
        nameSPT.text = post.name
        artistSPT.text = post.artist
        waitingView.hidden = true
        ytPlayerView.hidden = true
    }
    
    func setDelegates() {
        start.delegate = self
        end.delegate = self
        start.dataSource = self
        end.dataSource = self
    }
    
    func minutes() -> Int {
        return duration()/60
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
    
    func duration() -> Int {
        if let total = post.totalDuration {
            return total
        } else {
            let test = Int(ytPlayerView.duration())
            post.totalDuration = test != 0 ? test : nil
            return test
        }
    }
    
    func seconds() -> Int {
        return duration() - minutes() * 60
    }
    
    func extractDuration() -> Int {
        if (end.minutes() == 0){
            return end.seconds() + 1
        } else {
            return 60 - start.seconds() + end.seconds()
        }
    }
    @IBAction func playSPT(sender: AnyObject) {
        if !SpotifyHelper.isPlaying() {
            SpotifyHelper.play(post.playableURI!)
        } else {
            SpotifyHelper.play()
        }
    }
    
    @IBAction func pauseSPT(sender: AnyObject) {
        SpotifyHelper.pause()
    }
    
    @IBAction func back(sender: AnyObject) {
        pauseSPT(sender)
    }
  
    public func save() {
        pauseSPT(self)
        post.save(start: start.totalInSec(), end: extractDuration() + start.totalInSec(), duration: extractDuration())
    }
}


extension PlayerViewController : UIPickerViewDataSource {

    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    

    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 0){
            if (component == 0){
                return minutes() + 1
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
                var maxSec = 60
                if (end.minutes() == 0){
                    maxSec = start.minutes() == minutes() ? seconds() + 1 : 60
                    return min(maxSec - (start.seconds()+1),maxTimeInterval)
                } else {
                    maxSec = start.minutes() == minutes()-1 ? seconds() + 1 : 60
                    return min(maxSec, maxTimeInterval - 60 + (start.seconds()+1), maxTimeInterval)
                }
            }
        }
    }


}


extension PlayerViewController : UIPickerViewDelegate {
    
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
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
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        start.reloadAllComponents()
        end.reloadAllComponents()
    }

}


extension PlayerViewController : YTPlayerViewDelegate {

    public func playerViewDidBecomeReady(playerView: YTPlayerView) {
        infoReceived()
        start.reloadAllComponents()
        end.reloadAllComponents()
    }
    
    
}
















