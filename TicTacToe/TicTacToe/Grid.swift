//
//  Grid.swift
//  TicTacToe
//
//  Created by sinze vivens on 2020/2/3.
//  Copyright © 2020 Luke. All rights reserved.
//

import Foundation


class Grid{
    
    // -1: not occupied
    // 2: occupied by O
    // 3: occupied by X
    var squares: [Int]!
    
    init() {
        squares = [-1]
        for _ in 0...7{
            self.squares.append(-1)
        }
    }
    
    // return win piece type and combo that lead to a win(-1 if no winner)
    func isWin() -> (Int, [Int]){
        
        var status = -1
        // condition 1
        let r1 = squares[0]*squares[1]*squares[2]
        let r2 = squares[3]*squares[4]*squares[5]
        let r3 = squares[6]*squares[7]*squares[8]
        
        // condition 2
        let c1 = squares[0]*squares[3]*squares[6]
        let c2 = squares[1]*squares[4]*squares[7]
        let c3 = squares[2]*squares[5]*squares[8]
        
        // condition 3
        let d1 = squares[0]*squares[4]*squares[8]
        let d2 = squares[2]*squares[4]*squares[6]
        
        let result: [Int] = [r1, r2, r3,c1,c2,c3, d1,d2]
        
        for i in 0...result.count-1{
            if result[i] == 27{
                status = 3
                let combo = self.findWinnerGrid(combo: i, result: result)
                return (status, combo)
            }
            
            if result[i] == 8{
                status = 2
                let combo = self.findWinnerGrid(combo: i, result: result)
                return (status, combo)
            }
        }
        return (status, [-1,-1,-1])
    }
    
    // find grids that lead to a win from combo
    func findWinnerGrid(combo:Int, result: [Int]) ->[Int]{
        if combo >= 0 && combo < 3 {
            for i in 0...2{
                if result[i] == 27 || result[i] == 8{
                    let gridCombo = [i*3, i*3 + 1, i*3 + 2]
                    return gridCombo
                }
            }
        }else{}
        
        if combo >= 3 && combo < 6 {
           // print("till 1")
            for i in 0...2{
                if result[i+3] == 27 || result[i+3] == 8{
                   // print("till \(i+3)")
                    let gridCombo = [0+i, 3+i, 6+i]
                    return gridCombo
                }
            }
        }else{}
        
        if result[6] == 27 || result[6] == 8{
            let gridCombo = [0,4,8]
            return gridCombo
        }else{}
        
        if result[7] == 27 || result[7] == 8{
            let gridCombo = [2,4,6]
            return gridCombo
        }
        return [-1,-1,-1]
    }
    
    // determine whether there is a tie
    func isTie() -> Bool {
        var countOccupy = 0
        for i in 0...squares.count-1{
            if squares[i] != -1{
                countOccupy += 1
            }
        }
        let (winStatus, _) = isWin()
        if countOccupy == 9 && winStatus == -1 {
            return true
        }
        else{
            return false
        }
    }
    
    // determine whether the grid is occupied by a piece
    func isOccupied(index: Int)-> Bool{
        if squares[index] != -1{
            return true
        }
        else{
            return false
        }
        
    }
    // occupy a place for a piece
    func occupy(index: Int, isX: Bool){
        if isX == true{
            squares[index] = 3
        }
        else{
            squares[index] = 2
        }
    }
    
    // reset the grid board
    func reset(){
        for i in 0...squares.count-1{
            squares[i] = -1
        }
    }
    
    
}
