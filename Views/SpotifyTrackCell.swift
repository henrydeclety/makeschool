//
//  SpotifyTrackCell.swift
//  myApp
//
//  Created by Henry Declety on 7/23/16.
//  Copyright © 2016 Henry Declety. All rights reserved.
//

import UIKit

public class SpotifyTrackCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var duration: UILabel!

    public func fill(track track : Post) -> SpotifyTrackCell {
        name.text = track["name"] as? String
        artist.text = track["artist"] as? String
        duration.text = String(track["duration"] as! Int) + "s"
        return self
    }
    
    public func fill(trackDetails trackDetails : [NSObject : AnyObject]) -> SpotifyTrackCell {
        name.text = trackDetails["name"] as? String
        artist.text = trackDetails["artist"] as? String
        return self
    }
    
}
