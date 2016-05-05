//
//  ViewController.swift
//  MuralTest
//
//  Created by daniel mastracchio on 1/26/16.
//  Copyright © 2016 molol. All rights reserved.
//
// Pense hacer usando Sprite kit, porque podria tener buen manejo de animaciones y efectos.
// Pero lo hago con UIKit para integrar mas facil controles de texto y otro tipo de media
//
import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var canvasView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    var actualScale : CGFloat = 1.0
    var marqueeView : MarqueeView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: "handleTap:")
        tap.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(tap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: "handleDoubleTap:")
        doubleTap.numberOfTapsRequired = 2
        canvasView.addGestureRecognizer(doubleTap)
        
        //let zoom = UIPinchGestureRecognizer(target: self, action: "handlePinch:")
        //self.view.addGestureRecognizer(zoom)
        
        //let pan = UIPanGestureRecognizer(target: self, action: "handlePan:")
        //self.view.addGestureRecognizer(pan)

        let hold = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        canvasView.addGestureRecognizer(hold)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // cuando se toca el fondo, esconde el teclado que aparece por los controles de texto
    func handleTap(sender: UITapGestureRecognizer)
    {
        if sender.state == .Ended {
            
             self.view.endEditing(true)
        }
        if let v = marqueeView {
            v.stop()
            v.removeFromSuperview()
            marqueeView = nil
        }
    }

    func handleDoubleTap(sender: UITapGestureRecognizer)
    {
        if sender.state == .Ended {
            let position = sender.locationInView(self.view)
            let note = Note(position: position)
            
            canvasView.addSubview(note)
            //let tap = UITapGestureRecognizer(target: self, action: "handleTapOnNote:")
            //note.addGestureRecognizer(tap)
        }
    }
    
    func handlePinch(sender: UIPinchGestureRecognizer)
    {
        // guardo la escala para hacer zoom sucesivos
        let scale =   sender.scale //actualScale + sender.scale-1
            //print(actualScale)
            actualScale = scale
            let transform = CGAffineTransformScale(self.view.transform, actualScale, actualScale)
            self.view.transform = transform
            sender.scale = 1.0
        
    }
    
    func handlePan(sender: UIPanGestureRecognizer)
    {
        let translation = sender.translationInView(self.view)

        //let transform = CGAffineTransformTranslate(self.view.transform, translation.x, translation.
        //self.view.transform = transform
        self.view.center = CGPoint(x: self.view.center.x+translation.x, y: self.view.center.y+translation.y)
         sender.setTranslation(CGPointZero, inView: self.view)
    }
    
    func handleLongPress(sender: UILongPressGestureRecognizer)
    {
        let position = sender.locationInView(self.view)
        if sender.state == .Began {
            if marqueeView != nil {
                marqueeView!.stop()
                marqueeView!.removeFromSuperview()
            }
            marqueeView = MarqueeView(position: position)
            canvasView.addSubview(marqueeView!)
            
        } else if sender.state == .Ended {
            marqueeView!.addViews(scrollView.subviews)
        } else {
            marqueeView!.resize(position)
        }
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
            return canvasView
    }
    
    
}
