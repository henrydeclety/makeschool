//
//  CustomCell.swift
//  myApp
//
//  Created by Henry on 7/13/16.
//  Copyright © 2016 Henry Declety. All rights reserved.
//

import UIKit

public class YoutubeVideoCell: UITableViewCell {
 
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var duration: UILabel!

    
    public func fill(track : Post) -> YoutubeVideoCell {
        title.text = track["name"] as? String
        myImageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: (track["thumbnail"] as? String)!)!)!)
        duration.text = String(track["duration"] as! Int) + "s"
        return self
    }
    
    public func fill(trackDetails trackDetails : [NSObject : AnyObject]) -> YoutubeVideoCell {
        title.text = trackDetails["title"] as? String
        myImageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: (trackDetails["thumbnail"] as? String)!)!)!)
        return self
    }
    
    
    
}
