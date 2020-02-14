//
//  ViewController.swift
//  TicTacToe
//
//  Created by sinze vivens on 2020/1/30.
//  Copyright © 2020 Luke. All rights reserved.
//

/*
 - Attribution: https://stackoverflow.com/questions/27517632/how-to-create-a-delay-in-swift/27517642
 - Attribution: https://stackoverflow.com/questions/29616992/how-do-i-draw-a-circle-in-ios-swift
 - Attribution: https://stackoverflow.com/questions/31478630/animate-rotation-uiimageview-in-swift
 */

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var infoView: InfoView!
    @IBOutlet weak var infoViewButton: UIButton!
    @IBOutlet weak var infoViewLabel: UILabel!
    
    @IBOutlet weak var lineDrawView: UIView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var gridVIew: GridView!
    
    @IBOutlet var girds: [UIImageView]!
    
    @IBOutlet weak var xImgView: UIImageView!
    @IBOutlet weak var oImgView: UIImageView!
    

    var isXTurn:Bool = true
    let xPos = CGPoint(x:87.5,y:702.5)
    let oPos = CGPoint(x:329.5,y:702.5)
    let gridOnBoard:Grid = Grid()
    var isNewGame:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        // sort the grids by tag
        self.girds.sort { (gird1, gird2) -> Bool in
            return gird1.tag < gird2.tag
        }
        
        var panGesture  = UIPanGestureRecognizer()
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureHandler(recognizer: )))

        oImgView.isUserInteractionEnabled = true
        oImgView.addGestureRecognizer(panGesture)
        xImgView.isUserInteractionEnabled = true
        xImgView.addGestureRecognizer(panGesture)
        oImgView.alpha = 0.4
        
        infoButton.addTarget(self, action: #selector(ViewController.buttonTapped(_:)), for: .touchUpInside)
        infoViewButton.addTarget(self, action: #selector(ViewController.infoButtonTapped(_:)), for: .touchUpInside)
        
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = Double.pi * 2
        rotation.duration = 0.25 // or however long you want ...
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.xImgView.layer.add(rotation, forKey: "rotationAnimation")
        self.view.sendSubviewToBack(self.lineDrawView)
        
    }
    
    // determine whether the piece should be snapped into the grid and which grid if should be
    func isIntersects(grids: [UIImageView], center: CGPoint) -> Int{

        let relativePos = CGPoint(x:center.x-25, y: center.y-252)
        for i in 0...grids.count-1{
            if grids[i].frame.contains(relativePos){
                return i
            }
        }
        // should not be snapped
        return -1;
    }
    
    @IBAction func panGestureHandler(recognizer: UIPanGestureRecognizer){
        
        switch recognizer.state {
        case .ended:
            let endPos = CGPoint(x: recognizer.view!.center.x, y: recognizer.view!.center.y)
            //print("x is \(endPos.x) , y is \(endPos.y)")
            if self.isXTurn == true{
                UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn], animations: {
                    let index = self.isIntersects(grids: self.girds, center: endPos)
                    if index != -1 && !self.gridOnBoard.isOccupied(index: index){
                        let myNewPos = CGPoint(x: self.girds[index].center.x, y:self.girds[index].center.y)
                        let myOldPos = CGPoint(x:endPos.x-20, y:endPos.y-252)
                        self.snapIn(indexOfGrid: index, isXTurn: self.isXTurn, oldPos: myOldPos, newPos: myNewPos)
                        
                        // handle Grid
                        self.gridOnBoard.occupy(index: index, isX: true)
                        self.xImgView.layer.removeAnimation(forKey: "rotationAnimation")
                        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
                        rotation.toValue = Double.pi * 2
                        rotation.duration = 0.25 // or however long you want ...
                        rotation.isCumulative = true
                        rotation.repeatCount = Float.greatestFiniteMagnitude
                        self.oImgView.layer.add(rotation, forKey: "rotationAnimation")
                    }else{
                        recognizer.view!.center = CGPoint(x: self.xPos.x, y: self.xPos.y)
                    }
                    
                }, completion: { _ in
                    if self.isXTurn == true {
                        recognizer.view!.center = CGPoint(x: self.xPos.x, y: self.xPos.y)
                    }
                    else{
                        recognizer.view!.alpha = 0.4
                        self.oImgView.alpha = 1;
                        
                    }
                    // x wins
                    let (winStatus, winCombo) = self.gridOnBoard.isWin()
                    if winStatus == 3{
                        
                        // create shape layer for that path
                        self.view.bringSubviewToFront(self.lineDrawView)
                        
                        CATransaction.begin()
                        CATransaction.setAnimationDuration(1)
                        
                        CATransaction.setCompletionBlock{
                            self.lineDrawView.layer.sublayers?.removeAll()
                            self.view.sendSubviewToBack(self.lineDrawView)
                            UIView.animate(withDuration: 0.4, delay: 0.1, options: [.curveEaseIn], animations: {
                                self.infoView.center = CGPoint(x:207, y:400)
                                
                                self.infoViewButton.setTitle("OK", for: .normal)
                                self.infoViewButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
                                self.infoViewButton.setTitleColor(.white, for: .normal)
                                
                                self.infoViewLabel.text = "Congrats! X wins!"
                                self.infoViewLabel.font = UIFont.boldSystemFont(ofSize: 24)
                                self.infoViewLabel.textColor = UIColor.white
                                self.oImgView.layer.removeAnimation(forKey: "rotationAnimation")
                            }, completion: { _ in
                                self.isNewGame = true
                            })
                        }
                        
                        let start = CGPoint(x: self.girds[winCombo[0]].center.x, y:self.girds[winCombo[0]].center.y )
                        let end = CGPoint(x: self.girds[winCombo[2]].center.x, y:self.girds[winCombo[2]].center.y )
                        let path = UIBezierPath()
                        path.move(to: start)
                        path.addLine(to: end)
                        
                        let shapeLayer = CAShapeLayer()
                        shapeLayer.fillColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1).cgColor
                        shapeLayer.strokeColor = #colorLiteral(red: 0.3595919609, green: 0.597997725, blue: 0.5566628575, alpha: 1).cgColor
                        shapeLayer.lineWidth = 8
                        shapeLayer.path = path.cgPath
                        
                        self.lineDrawView.layer.addSublayer(shapeLayer)
                        let animation = CABasicAnimation(keyPath: "strokeEnd")
                        animation.fromValue = 0
                        animation.toValue = 1
                        animation.duration = CFTimeInterval(1)
                        self.lineDrawView.layer.add(animation, forKey: "drawLine")
                        
                        CATransaction.commit()
                    }
                    // is a tie
                    if self.gridOnBoard.isTie(){
                        UIView.animate(withDuration: 0.4, delay: 0.1, options: [.curveEaseIn], animations: {
                            self.infoView.center = CGPoint(x:207, y:400)
                            
                            self.infoViewButton.setTitle("OK", for: .normal)
                            self.infoViewButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
                            self.infoViewButton.setTitleColor(.white, for: .normal)
                            
                            self.infoViewLabel.text = "Oops, it is a tie."
                            self.infoViewLabel.font = UIFont.boldSystemFont(ofSize: 24)
                            self.infoViewLabel.textColor = UIColor.white
                            self.xImgView.layer.removeAnimation(forKey: "rotationAnimation")
                            self.oImgView.layer.removeAnimation(forKey: "rotationAnimation")
                        }, completion: { _ in
                            self.isNewGame = true
                        })
                    }
                })
                recognizer.view!.center = CGPoint(x: self.xPos.x, y: self.xPos.y)
            }
            else{
                UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
                    let index = self.isIntersects(grids: self.girds, center: endPos)
                    //print(index)
                    if index != -1 && !self.gridOnBoard.isOccupied(index: index){
                        let myNewPos = CGPoint(x: self.girds[index].center.x, y:self.girds[index].center.y)
                        let myOldPos = CGPoint(x:endPos.x-25, y:endPos.y-252)
                        self.snapIn(indexOfGrid: index, isXTurn: self.isXTurn, oldPos: myOldPos, newPos: myNewPos)
                        
                        // handle Gird
                        self.gridOnBoard.occupy(index: index, isX: false)
                        
                        self.oImgView.layer.removeAnimation(forKey: "rotationAnimation")
                        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
                        rotation.toValue = Double.pi * 2
                        rotation.duration = 0.25 // or however long you want ...
                        rotation.isCumulative = true
                        rotation.repeatCount = Float.greatestFiniteMagnitude
                        self.xImgView.layer.add(rotation, forKey: "rotationAnimation")
                    }else{
                        recognizer.view!.center = CGPoint(x: self.oPos.x, y: self.oPos.y)
                    }
                }, completion: { _ in
                    if self.isXTurn == false {
                        recognizer.view!.center = CGPoint(x: self.oPos.x, y: self.oPos.y)
                    }
                    else{
                        recognizer.view!.alpha = 0.4
                        self.xImgView.alpha = 1
                    }
                    
                    // 0 wins
                    let (winStatus, winCombo) = self.gridOnBoard.isWin()
                    if winStatus == 2{
                        
                        self.view.bringSubviewToFront(self.lineDrawView)
                        CATransaction.begin()
                        CATransaction.setAnimationDuration(1)
                        CATransaction.setCompletionBlock{
                            self.lineDrawView.layer.sublayers?.removeAll()
                            self.view.sendSubviewToBack(self.lineDrawView)
                            UIView.animate(withDuration: 0.4, delay: 0.1, options: [.curveEaseIn], animations: {
                                self.infoView.center = CGPoint(x:207, y:400)
                                
                                self.infoViewButton.setTitle("OK", for: .normal)
                                self.infoViewButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
                                self.infoViewButton.setTitleColor(.white, for: .normal)
                                
                                self.infoViewLabel.text = "Congrats! O wins!"
                                self.infoViewLabel.font = UIFont.boldSystemFont(ofSize: 24)
                                self.infoViewLabel.textColor = UIColor.white
                                self.xImgView.layer.removeAnimation(forKey: "rotationAnimation")
                            }, completion: { _ in
                                self.isNewGame = true
                            })
                        }
                        let start = CGPoint(x: self.girds[winCombo[0]].center.x, y:self.girds[winCombo[0]].center.y)
                        let end = CGPoint(x: self.girds[winCombo[2]].center.x, y:self.girds[winCombo[2]].center.y)
                        let path = UIBezierPath()
                        path.move(to: start)
                        path.addLine(to: end)
                        
                        let shapeLayer = CAShapeLayer()
                        shapeLayer.fillColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1).cgColor
                        shapeLayer.strokeColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1).cgColor
                        shapeLayer.lineWidth = 8
                        shapeLayer.path = path.cgPath
                        
                        self.lineDrawView.layer.addSublayer(shapeLayer)
                        let animation = CABasicAnimation(keyPath: "strokeEnd")
                        animation.fromValue = 0
                        animation.toValue = 1
                        //animation.duration = CFTimeInterval(2)
                        self.lineDrawView.layer.add(animation, forKey: "drawLine")
                        
                        CATransaction.commit()
                    }
                    // is a tie
                    if self.gridOnBoard.isTie(){
                        print(" is a tie")
                        UIView.animate(withDuration: 0.4, delay: 0.1, options: [.curveEaseIn], animations: {
                            self.infoView.center = CGPoint(x:207, y:400)
                            
                            self.infoViewButton.setTitle("OK", for: .normal)
                            self.infoViewButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
                            self.infoViewButton.setTitleColor(.white, for: .normal)
                            
                            self.infoViewLabel.text = "Oops, it is a tie."
                            self.infoViewLabel.font = UIFont.boldSystemFont(ofSize: 24)
                            self.infoViewLabel.textColor = UIColor.white
                            self.xImgView.layer.removeAnimation(forKey: "rotationAnimation")
                            self.oImgView.layer.removeAnimation(forKey: "rotationAnimation")
                        }, completion: { _ in
                            self.isNewGame = true
                        })
                    }
                    
                })
                recognizer.view!.center = CGPoint(x: self.oPos.x, y: self.oPos.y)
                
            }
            
            
        case .changed:
            recognizer.view?.layer.removeAnimation(forKey: "rotationAnimation")
            let translation = recognizer.translation(in: self.view)
            if let view = recognizer.view {
                view.center = CGPoint(x:view.center.x + translation.x,
                                      y:view.center.y + translation.y)
            }
            
        default:
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
    // snap-in animation and call changeTurn
    func snapIn(indexOfGrid: Int, isXTurn: Bool, oldPos: CGPoint, newPos: CGPoint){
        
        self.girds[indexOfGrid].center = oldPos
        let animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut) {
               }
        animator.addAnimations {
            if isXTurn == true{
                self.girds[indexOfGrid].image = UIImage(named: "xImg")
                self.girds[indexOfGrid].center = newPos
            }
            else{
                self.girds[indexOfGrid].image = UIImage(named: "oImg")
                self.girds[indexOfGrid].center = newPos
            }
        }
        animator.startAnimation()
        self.changeTurn()
        
    }
    
    // change the player's turn
    func changeTurn(){
        if self.isXTurn == true{
            self.isXTurn = false;
            self.xImgView.isUserInteractionEnabled = false
            self.oImgView.isUserInteractionEnabled = true
            var panGesture  = UIPanGestureRecognizer()
                   panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureHandler(recognizer: )))
            self.oImgView.addGestureRecognizer(panGesture)
        }
        else{
            self.isXTurn = true;
            self.oImgView.isUserInteractionEnabled = false
            self.xImgView.isUserInteractionEnabled = true
            var panGesture  = UIPanGestureRecognizer()
                   panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureHandler(recognizer: )))
            self.xImgView.addGestureRecognizer(panGesture)
        }
    }
    
    @objc func buttonTapped(_ button: UIButton){
        
        UIView.animate(withDuration: 0.4, delay: 0.1, options: [.curveEaseIn], animations: {
            self.infoView.center = CGPoint(x:207, y:400)
            
            self.infoViewButton.setTitle("OK", for: .normal)
            self.infoViewButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
            self.infoViewButton.setTitleColor(.white, for: .normal)
            
            self.infoViewLabel.text = "Get 3 in a row to win!"
            self.infoViewLabel.font = UIFont.boldSystemFont(ofSize: 24)
            self.infoViewLabel.textColor = UIColor.white
        }, completion: { _ in
        })
    }
    
    // info button "ok"
    @objc func infoButtonTapped(_ button: UIButton){
        
        UIView.animate(withDuration: 0.4, delay: 0.1, options: [.curveEaseIn], animations: {
            self.infoView.center = CGPoint(x:207, y:1000)
        }, completion: { _ in
            self.infoView.center = CGPoint(x:207, y:-99)
        })
        
        if(self.isNewGame == true){
            
            UIView.animate(withDuration: 1.2, delay: 0, options: [.curveEaseIn], animations: {
                for i in 0...self.girds.count-1{
                    self.girds[i].alpha = 0.1
                }
            }, completion: { _ in
                self.clearGird()
                self.isNewGame = false
            })
            
        }
        
        
    }
    
    // clear the grid and reset the info stored in Grid Class
    func clearGird(){
        for i in 0...girds.count-1{
            self.girds[i].image = nil
        }
        self.isXTurn = true
        self.gridOnBoard.reset()
        self.oImgView.isUserInteractionEnabled = false
        self.xImgView.isUserInteractionEnabled = true
        var panGesture  = UIPanGestureRecognizer()
               panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureHandler(recognizer: )))
        self.xImgView.addGestureRecognizer(panGesture)
        self.xImgView.alpha = 1
        self.oImgView.alpha = 0.4
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = Double.pi * 2
        rotation.duration = 0.25
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.xImgView.layer.add(rotation, forKey: "rotationAnimation")
        
        for i in 0...self.girds.count-1{
            self.girds[i].alpha = 1
        }
        
    }


}

