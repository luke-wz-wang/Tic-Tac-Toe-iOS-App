//
//  InfoView.swift
//  TicTacToe
//
//  Created by sinze vivens on 2020/2/2.
//  Copyright © 2020 Luke. All rights reserved.
//

/*
 - Attribute: playground from lecture
 */

import UIKit


class InfoView: UIView {
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.backgroundColor = UIColor(red: 153/255, green: 153/255, blue: 255/255, alpha: 1.0).cgColor
        
        layer.cornerRadius = 20
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 4
        
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 2
        layer.shadowOffset = CGSize(width: 5, height: 5)

       }
    

}
