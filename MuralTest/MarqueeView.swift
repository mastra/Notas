//
//  MarqueeView.swift
//  MuralTest
//
//  Created by daniel mastracchio on 2/17/16.
//  Copyright © 2016 molol. All rights reserved.
//

import UIKit

class MarqueeView: UIView {
    let W : CGFloat = 10
    let H : CGFloat = 10
    var initialX : CGFloat = 0.0
    var initialY : CGFloat = 0.0
    var containedViews = [Note]()
    
    init(position: CGPoint) {
        initialX = position.x
        initialY = position.y
        super.init(frame: CGRectMake(position.x, position.y, W, H))
        self.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.39, alpha: 0.5)
        let pan = UIPanGestureRecognizer(target: self, action: "handlePan:")
        self.addGestureRecognizer(pan)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resize(position: CGPoint)
    {
        let x = min(position.x, initialX)
        let y = min(position.y, initialY)
        
        let width = abs( position.x - initialX )
        let height = abs ( position.y - initialY )
        
        self.frame = CGRect(x: x, y: y, width: width, height: height)
    }
    
    func addViews(views: [UIView]) {
        for view in views {
            if let note = view as? Note {
                if self.frame.contains(note.frame) {
                    containedViews.append(note)
                    note.shake(true)
                }
            }
        }
    }
    
    func stop() {
        for note in containedViews {
            note.shake(false)
        }
    }
    
    func handlePan(sender: UIPanGestureRecognizer)
    {
        self.superview!.bringSubviewToFront(self)
        let translation = sender.translationInView(self.superview!)
        self.center = CGPoint(x: self.center.x+translation.x, y: self.center.y+translation.y)
        sender.setTranslation(CGPointZero, inView:self.superview!)
        
        for note in containedViews {
            note.center = CGPoint(x: note.center.x+translation.x, y: note.center.y+translation.y)
        }
    }
}
