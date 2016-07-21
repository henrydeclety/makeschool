//
//  MatchesCellTableViewCell.swift
//  myApp
//
//  Created by Henry Declety on 7/20/16.
//  Copyright © 2016 Henry Declety. All rights reserved.
//

import UIKit

class MatchesCell: UITableViewCell {
    
    
    @IBOutlet weak var descriptionView: UILabel!
    @IBOutlet weak var title: UILabel!
    var name : String?
    var age : String?
    var sex : String?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func displayUser(user : User){
        descriptionView.text = user["description"] as? String ?? ""
        age = String(user["age"] as! Int)
        sex = user["sex"] as! Bool ? "Man" :  "Woman"
        name = (user["name"] as! String)
        title.text = name! + ", " + age!
    }

}
