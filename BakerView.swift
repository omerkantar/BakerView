//
//  BakerView.swift
//  Baker
//
//  Created by omer on 16.05.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit

@IBDesignable class BakerView: UIView {

    var rainbowLayer: CAGradientLayer?
    
    var colors: [CGColor]?
    
    @IBInspectable var animation: Bool = false {
        didSet {
            if animation {
                startAnimation()
            }else {
                stopAnimation()
            }
        }
    }
    
    @IBInspectable var animationDuration: CGFloat = 0.5
    
    
    override func draw(_ rect: CGRect) {
        buildRainbowLayerIfNeeded()
    }
    
}


// MARK: - Animation Start & Stop
extension BakerView {
    
    func startAnimation() {
        buildRainbowLayerIfNeeded()
        self.layer.addSublayer(rainbowLayer!)
        animating()
    }
    
    func stopAnimation() {
        removeRainbowLayer()
    }
    
}


// MARK: - CAAnimationDelegate

extension BakerView: CAAnimationDelegate {
    func animating() {
        if let rainbow = rainbowLayer,
            let colors = colors {
            
            let lastColor = colors.last
            self.colors?.remove(at: ((colors.endIndex) - 1))
            self.colors?.insert(lastColor!, at: 0)

            rainbow.colors = self.colors
            
            let animation = CABasicAnimation(keyPath: "colors")
            animation.toValue = self.colors
            animation.duration = CFTimeInterval(self.animationDuration)
            animation.isRemovedOnCompletion = false
            animation.fillMode = kCAFillModeForwards
            animation.delegate = self
            rainbow.add(animation, forKey: "rainbow")
            
        }
    }
    
    func animationDidStart(_ anim: CAAnimation) { }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if animation == false {
            return
        }
        animating()
    }
}




// MARK: - Rainbow Layer
extension BakerView {
    
    func buildRainbowLayerIfNeeded() {
        
        if colors == nil {
            colors = self.getColors()
        }
        
        if rainbowLayer == nil {
            rainbowLayer = CAGradientLayer()
            rainbowLayer?.frame = CGRect(origin: CGPoint.zero, size: self.frame.size)
            rainbowLayer?.startPoint = CGPoint(x: 0.0, y: 0.5)
            rainbowLayer?.endPoint = CGPoint(x: 1.0, y: 0.5)
            rainbowLayer?.colors = colors
            
        }
    }
    
    func removeRainbowLayer() {
        if let rainbowLayer = rainbowLayer {
            rainbowLayer.removeAllAnimations()
            rainbowLayer.removeFromSuperlayer()
            self.rainbowLayer = nil
        }
    }
    
    
    func getColors() -> [CGColor] {
        var colors = [CGColor]()
        
        var hue = 0.0

        repeat {
            let color = UIColor(hue: CGFloat(1.0 * hue / 360.0), saturation: 1.0, brightness: 1.0, alpha: 1.0)
            colors.append(color.cgColor)
            hue += 5.0
            
        } while hue <= 360.0
        
        return colors
    }
}
