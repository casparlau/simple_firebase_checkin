//
//  CheckInManager.swift
//  CheckInOMAPP
//
//  Created by Caspar on 26/2/2017.
//  Copyright © 2017 OMAPP. All rights reserved.
//

class CheckInManager {
    
    static let sharedInstance = CheckInManager()
    
    private var isLoggedIn : Bool?

    func isLogged() -> Bool{
        return isLoggedIn!
    }
    
    func setLogin(isLogin : Bool){
        isLoggedIn = isLogin
    }
    
    
    
    
}




