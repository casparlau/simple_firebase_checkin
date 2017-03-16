//
//  Constants.swift
//  CheckInOMAPP
//
//  Created by MegaHub on 21/2/2017.
//  Copyright © 2017 Sarah Allen. All rights reserved.
//

import Foundation

struct Constants  {

    
    static let omappFirebaseGroupPath = "group/omapp/"
    static let jellyFirebaseGroupPath = "group/jellyfish/"
    
    static var buildMode:CheckInGroup = CheckInGroup.OMAPP
    
    enum CheckInGroup : Int {
        case OMAPP = 0
        case JELLYFISH = 1
    }
    
}
