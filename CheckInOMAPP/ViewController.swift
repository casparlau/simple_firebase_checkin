//
//  ViewController.swift
//  FirebasePlayground
//
//  Created by Sarah Allen on 3/13/16.
//  Copyright © 2016 Sarah Allen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
    @IBOutlet var m_oCheckInButton : UIButton!
    @IBOutlet var m_oLogButton : UIButton!
    
    var writeRef : FIRDatabaseReference!
    var baseRef : FIRDatabaseReference!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        /* Creating a reference does not create a connection to the server or begin downloading data. Data is not fetched until a read or write operation is invoked.
         */
        // Read
        
        
        signIn()
        
        
        let myRootRef = FIRDatabase.database().reference()

        
        let now = Date()
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "yyyyMM"
        let currentMonth = monthFormatter.string(from: now)
        baseRef = myRootRef.child(Constants.omappFirebaseGroupPath + "/" + currentMonth)

        
//        createEmail()
        
    }
    
    func signIn() {
        FIRAuth.auth()?.signIn(withEmail: "jellyfish@omapp.com", password: "123456") { (user, error) in
            let user = FIRAuth.auth()?.currentUser
            let email = user?.email
            let uid = user?.uid
            
            if uid != nil{
//                self.checkIn()
                print (email!)
            }
        }
    }
    
    func createEmail () {
        FIRAuth.auth()?.createUser(withEmail: "jellyfish@omapp.com", password: "123456") { (user, error) in
            if error != nil {
                print(error!.localizedDescription )
            }
        }
        
    }
    
    func logOn(){
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        
        let currentTime = formatter.string(from: now)
        
        writeRef = baseRef.childByAutoId();

        writeRef.child("checkin_time").setValue(currentTime)
     
    
        writeRef.child("checkin_time").observeSingleEvent(of:.value, with: { (snapshot) -> Void in
            let checkinTime : String = snapshot.value as! String
            
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "yyyyMMddHHmmss"
            let displayDate = displayFormatter.date(from: checkinTime)
            displayFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            if(displayDate != nil){
                let displayDateString = displayFormatter.string(from: displayDate!)
                
                
                let alert = UIAlertController(title: "Check In Success", message: "Check In Time:\n" + displayDateString , preferredStyle: UIAlertControllerStyle.alert)
                
                DispatchQueue.main.async { () -> Void in
                    self.present(alert, animated: true, completion: nil)
                }
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            }
        })

    }
    
    func logOff(){

        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        
        let currentTime = formatter.string(from: now)
        
        
        writeRef.child("checkout_time").setValue(currentTime)
        
        writeRef.child("checkout_time").observeSingleEvent(of:.value, with: { (snapshot) -> Void in
            let checkinTime : String = snapshot.value as! String
            
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "yyyyMMddHHmmss"
            let displayDate = displayFormatter.date(from: checkinTime)
            displayFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            if(displayDate != nil){
                let displayDateString = displayFormatter.string(from: displayDate!)
                
                
                let alert = UIAlertController(title: "Check Out Success", message: "Check Out Time:\n" + displayDateString , preferredStyle: UIAlertControllerStyle.alert)
                
                DispatchQueue.main.async { () -> Void in
                    self.present(alert, animated: true, completion: nil)
                }
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            }
        })

    }
    
    @IBAction func checkIn() {
        
        
        if(!CheckInManager.sharedInstance.isLogged()){
            CheckInManager.sharedInstance.setLogin(isLogin: true)
            m_oCheckInButton.setTitle("Check Out", for: .normal)
            logOn()
            
        }else{
            CheckInManager.sharedInstance.setLogin(isLogin: false)
            m_oCheckInButton.setTitle("Check In", for: .normal)
            logOff()

        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        navigationItem.title = nil
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

