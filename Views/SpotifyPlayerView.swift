//
//  SpotifyPlayerView.swift
//  myApp
//
//  Created by Henry Declety on 7/25/16.
//  Copyright © 2016 Henry Declety. All rights reserved.
//

import UIKit

class SpotifyPlayerView: UIView {

    @IBOutlet weak var playPauseSPT: UIButton!

    
    @IBAction func playPauseSPT(sender: AnyObject, post : Post) {
        if SpotifyHelper.isPlaying() {
            playPauseSPT.setImage(UIImage(named: "Play.png"), forState: UIControlState.Normal)
            SpotifyHelper.pause()
        } else {
            playPauseSPT.setImage(UIImage(named: "Pause.png"), forState: UIControlState.Normal)
            SpotifyHelper.play()
        }
    }
    

}
