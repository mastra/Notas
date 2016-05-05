//
//  Note.swift
//  MuralTest
//
//  Created by daniel mastracchio on 1/26/16.
//  Copyright © 2016 molol. All rights reserved.
//

import UIKit

// la clase Note contiene las propiedades y  funcionalidad del sticky, 
// contiene un campo de texto, con color random y el manejo de moverse
//
class Note : UIView {
    var textView = UITextView()
    
    // le doy dimensiones por defecto. Podria ser resizable
    let W : CGFloat = 100
    let H : CGFloat = 100
    let Border : CGFloat = 6
    let FontSize : CGFloat = 16
    
    func noteInit() {
        self.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 0.9)
        // pongo el texto dejando un espacio libre. donde ese puede tocar para mover la nota
        textView.frame = CGRectMake(Border,Border,self.bounds.size.width-2*Border, self.bounds.size.height-2*Border)
        textView.font = UIFont(name: "ProximaNova-Regular", size: FontSize)
        textView.text = "Type here..."
        textView.textColor = UIColor(white: 0.15, alpha: 1.0)
        textView.backgroundColor = randomColor()
        self.addSubview(textView)
        let pan = UIPanGestureRecognizer(target: self, action: "handlePanOnNote:")
        self.addGestureRecognizer(pan)
    }
    
    init(position: CGPoint) {
        super.init(frame: CGRectMake(position.x, position.y, W, H))
        noteInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        noteInit()
    }

    func randomColor() -> UIColor
    {
        let red : CGFloat = CGFloat(arc4random_uniform(100)+156)/256.0
        let green : CGFloat = CGFloat(arc4random_uniform(100)+156)/256.0
        let blue : CGFloat = CGFloat(arc4random_uniform(100)+156)/256.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    func handlePanOnNote(sender: UIPanGestureRecognizer)
    {
        
        self.superview!.bringSubviewToFront(self)
        let translation = sender.translationInView(self.superview!)
        self.center = CGPoint(x: self.center.x+translation.x, y: self.center.y+translation.y)
        sender.setTranslation(CGPointZero, inView:self.superview!)
    }

    // muestro la nota arriba de todo
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.superview!.bringSubviewToFront(self)
    }
    
    func shake(move: Bool)
    {
        if move {
            let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            animation.duration = 0.2
            animation.values = [ -4.0, 4.0]
            animation.autoreverses = true
            animation.repeatCount = 20
            layer.addAnimation(animation, forKey: "shake")
            
        } else {
            layer.removeAllAnimations()
        }
    }
}
