//
//  TimePicker.swift
//  myApp
//
//  Created by Henry on 7/15/16.
//  Copyright © 2016 Henry Declety. All rights reserved.
//

import UIKit

public class TimePickerView : UIPickerView {
    
    public func minutes() -> Int {
        return selectedRowInComponent(0)
    }
    
    public func seconds() -> Int {
        return selectedRowInComponent(1)
    }
    
}
