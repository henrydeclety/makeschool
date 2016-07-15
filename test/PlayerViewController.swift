//
//  PlayerViewController.swift
//  myApp
//
//  Created by Henry on 7/14/16.
//  Copyright © 2016 Henry Declety. All rights reserved.
//

import UIKit
import youtube_ios_player_helper


class PlayerViewController: UIViewController {
    
    var videoID: String!
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var start: UIDatePicker!
    @IBOutlet weak var end: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.loadWithVideoId(videoID)
    }
    
    @IBAction func save(sender: AnyObject) {
    }
}
