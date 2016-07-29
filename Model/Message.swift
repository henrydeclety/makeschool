//
//  Message.swift
//  myApp
//
//  Created by Henry Declety on 7/28/16.
//  Copyright © 2016 Henry Declety. All rights reserved.
//

import Foundation
import JSQMessagesViewController


class Message : NSObject, JSQMessageData {
    var text_: String
    var sender_: String
    var date_: NSDate
    var imageUrl_: String?
    
    convenience init(text: String?, sender: String?) {
        self.init(text: text, sender: sender, imageUrl: nil)
    }
    
    init(text: String?, sender: String?, imageUrl: String?) {
        self.text_ = text!
        self.sender_ = sender!
        self.date_ = NSDate()
        self.imageUrl_ = imageUrl
    }
    
    func senderDisplayName() -> String! {
        return "Jean Charles"
    }
    
    func isMediaMessage() -> Bool {
        return false
    }
    
    func date() -> NSDate! {
        return date_
    }

    func messageHash() -> UInt {
        return 455
    }
    
    
    func text() -> String! {
        return text_;
    }
    func senderId() -> String! {
        return sender_;
    }
    
    func imageUrl() -> String? {
        return imageUrl_;
    }
}