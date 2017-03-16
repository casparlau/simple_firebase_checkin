//
//  TitleValueCell.swift
//  CheckInOMAPP
//
//  Created by Caspar on 12/3/2017.
//  Copyright © 2017 OMAPP. All rights reserved.
//

import UIKit

class TitleValueCell: UITableViewCell {
    
    var leftLabel: UILabel!
    var rightLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
     
        leftLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width/2, height: self.frame.height))
        leftLabel.textAlignment = .center
        leftLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(leftLabel)
        
//        let line = UIView (frame: CGRect(x: self.frame.width/2, y: 0, width: 1, height: self.frame.width/2))
//        line.backgroundColor = UIColor.white
//        self.addSubview(line)
        
        rightLabel = UILabel(frame: CGRect(x: self.frame.width/2 + 5, y: 0, width: self.frame.width/2 - 5, height: self.frame.height))
        rightLabel.textAlignment = .center
        rightLabel.adjustsFontSizeToFitWidth = true

        self.addSubview(rightLabel)
    
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    
}
