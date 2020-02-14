//
//  GridView.swift
//  TicTacToe
//
//  Created by sinze vivens on 2020/1/30.
//  Copyright © 2020 Luke. All rights reserved.
//

import UIKit

class GridView: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let width = rect.width
        let height = rect.height
        
      
        let lines = UIBezierPath()
        
        lines.move(to: CGPoint(x: 0 + 5, y: 1 * height / 3))
        lines.addLine(to: CGPoint(x: width - 5, y: height * 1 / 3))
        
        lines.move(to: CGPoint(x: 0 + 5, y: 2 * height / 3))
        lines.addLine(to: CGPoint(x: width - 5, y: height * 2 / 3))
        
        lines.move(to: CGPoint(x: width * 1 / 3, y: 0 + 5))
        lines.addLine(to: CGPoint(x: width * 1 / 3, y: height - 5))
        
        lines.move(to: CGPoint(x: width * 2 / 3, y: 0 + 5))
        lines.addLine(to: CGPoint(x: width * 2 / 3, y: height - 5))
        
        let lineColor = UIColor(red: 158/255, green: 255/255, blue: 102/255, alpha: 1.0)
        lineColor.setStroke()
        
        lines.lineWidth = 8
        lines.stroke()
        
    }
    
    
    

}
