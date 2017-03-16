//
//  CheckInViewController.swift
//  checkin
//
//  Created by Caspar on 18/2/2017.
//  Copyright © 2017 Caspar. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ActivityLogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var m_oTableView: UITableView!
    @IBOutlet var m_oSegmentedControl: UISegmentedControl!
    @IBOutlet var m_oMonthPicker: UIPickerView!
    
    var m_oOMAPPArrayList: NSMutableArray!
    var m_oJellyFishList: NSMutableArray!
    
    
    var m_oSelectedGroup : Constants.CheckInGroup!
    var m_oDateFormatter : DateFormatter!
    var m_oMonthPickerData: [String] = [String]()
    
    var currentMonth : Int!
    var currentDate : String!
    
    var dataRef : FIRDatabaseReference!
    
    var now : Date!


    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        m_oOMAPPArrayList = NSMutableArray()
        m_oJellyFishList = NSMutableArray()
        m_oDateFormatter = DateFormatter()
        

        
    }
    
    @IBAction func onIndexClicked(_ sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex == Constants.CheckInGroup.OMAPP.rawValue){
            m_oSelectedGroup = Constants.CheckInGroup.OMAPP
            
        }else{
            m_oSelectedGroup = Constants.CheckInGroup.JELLYFISH
            
        }
        self.m_oTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        let user = FIRAuth.auth()?.currentUser
        let email = user?.email
        let uid = user?.uid
        
        m_oTableView.delegate = self
        m_oTableView.dataSource = self
        
        m_oSelectedGroup = Constants.CheckInGroup.OMAPP
        
        m_oMonthPickerData = ["Jan", "Feb", "Mar", "Apr", "May", "June", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        m_oMonthPicker.delegate = self
        m_oMonthPicker.dataSource = self
        
        
        now = Date()
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMM"
        
        currentMonth =  Int(monthFormatter.string(from: now))!
        let currentMonthIndex = currentMonth - 1
        m_oMonthPicker.selectRow(currentMonthIndex, inComponent: 0, animated: false)
        
        currentDate = dateFormatter.string(from: now)

        
        if user?.email != nil{
            getCheckInDataOnce(Constants.CheckInGroup.OMAPP)
            getCheckInDataOnce(Constants.CheckInGroup.JELLYFISH)
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getCheckInDataOnce(_ selectedGroup : Constants.CheckInGroup){
        
        let myRootRef = FIRDatabase.database().reference()
        switch selectedGroup {
        case .OMAPP:
            dataRef = myRootRef.child(Constants.omappFirebaseGroupPath).child(currentDate)
            dataRef.observe(.value, with: { (snapshot) in
                
                let dict = snapshot.value as? NSDictionary
                self.m_oOMAPPArrayList.removeAllObjects()
                
                if(dict != nil){
                    
                    for(_,varDict) in dict!{
                        let obj :TimePairObj = TimePairObj()
                        
                        let innerDict =  varDict as? NSDictionary
                        
                        if innerDict != nil{
                            obj.checkInTime = innerDict?["checkin_time"] as? String
                            obj.checkOutTime = innerDict?["checkout_time"] as? String
                        }
                        self.m_oOMAPPArrayList.addObjects(from: [obj])
                    
                    }
                    let sortDescriptor = NSSortDescriptor(key: "self.checkInTime", ascending: false,
                                                          selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
                    self.m_oOMAPPArrayList.sort(using: [sortDescriptor])

                }
                DispatchQueue.main.async {
                    self.m_oTableView.reloadData()
                }
                
                
            
            }) { (error) in
                print(error.localizedDescription)
            }
            
        case .JELLYFISH:
            dataRef = myRootRef.child(Constants.jellyFirebaseGroupPath).child(currentDate)
            dataRef.observe(.value, with: { (snapshot) in
                
                let dict = snapshot.value as? NSDictionary
                self.m_oJellyFishList.removeAllObjects()
            
                if (dict != nil ){
                    for(_,varDict) in dict!{
                        let obj :TimePairObj = TimePairObj()
                        
                        let innerDict =  varDict as? NSDictionary
                        
                        if innerDict != nil{
                            
                            
                            obj.checkInTime = innerDict?["checkin_time"] as? String
                            obj.checkOutTime = innerDict?["checkout_time"] as? String
                        }
                        self.m_oJellyFishList.addObjects(from: [obj])
                        
                        
                    }
                    
                    let sortDescriptor = NSSortDescriptor(key: "self.checkInTime", ascending: false,
                                                          selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
                    self.m_oJellyFishList.sort(using: [sortDescriptor])

                }
                
                
                DispatchQueue.main.async {
                    self.m_oTableView.reloadData()
                }
                

            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }

    

    func sortFunc(num1: Int, num2: Int) -> Bool {
        return num1 < num2
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        if m_oSelectedGroup == Constants.CheckInGroup.OMAPP{
            return self.m_oOMAPPArrayList.count
        }else{
            return self.m_oJellyFishList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell :TitleValueCell = TitleValueCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "TitleValueCell")
        
        cell.textLabel!.textColor = UIColor.white
        var rawObject : TimePairObj
        
        if m_oSelectedGroup == Constants.CheckInGroup.OMAPP{
            rawObject = self.m_oOMAPPArrayList.object(at: indexPath.row) as! TimePairObj
        }else{
            rawObject = self.m_oJellyFishList.object(at: indexPath.row) as! TimePairObj

        }
        if(rawObject.checkInTime != nil){
            m_oDateFormatter.dateFormat = "yyyyMMddHHmmss"
            let date = m_oDateFormatter.date(from: rawObject.checkInTime! )
            m_oDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let displayString = m_oDateFormatter.string(from: date!)
            cell.leftLabel?.text = displayString
        }
        
        if(rawObject.checkOutTime != nil){
            m_oDateFormatter.dateFormat = "yyyyMMddHHmmss"
            let date = m_oDateFormatter.date(from: rawObject.checkOutTime! )
            m_oDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let displayString = m_oDateFormatter.string(from: date!)
            cell.rightLabel?.text = displayString
        }
        
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "CheckIn Time   |   CheckOut Time"
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
        
    }
    
    // MARK: UIPickerDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return m_oMonthPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return m_oMonthPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dataRef.removeAllObservers()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        
        let selectedMonth : Int = row + 1
        currentDate = dateFormatter.string(from: now)
        currentDate.append(String(format:"%02d",selectedMonth))
        
        getCheckInDataOnce(Constants.CheckInGroup.OMAPP)
        getCheckInDataOnce(Constants.CheckInGroup.JELLYFISH)
    }
    
    @IBAction func onBackBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

