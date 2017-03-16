//
//  TimePairObj.swift
//  CheckInOMAPP
//
//  Created by Caspar on 12/3/2017.
//  Copyright © 2017 OMAPP. All rights reserved.
//

import Foundation

class TimePairObj: NSObject {
    var checkInTime: String?
    var checkOutTime: String?
    
    override var description : String {
        return "checkInTime:\(checkInTime), checkOutTime:\(checkOutTime)"
    }
    
}

