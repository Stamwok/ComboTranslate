//
//  CustomProgressView.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 17.03.22.
//

import UIKit

@IBDesignable
class VerticalProgressView: UIView {
    @IBInspectable var color: UIColor? = .gray
    
    var progress: Float = 0 {
        didSet {
            progressLayer.removeFromSuperlayer()
            progressLayer = CALayer()
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let backgroundMask = CAShapeLayer()
        backgroundMask.path = UIBezierPath(roundedRect: rect, cornerRadius: rect.height * 0.25).cgPath
        layer.mask = backgroundMask
        
        let progressRect = CGRect(origin: CGPoint(x: 0, y: rect.height), size: CGSize(width: rect.width, height: -(rect.height * CGFloat(progress))))
        progressLayer.frame = progressRect
        
        layer.addSublayer(progressLayer)
        progressLayer.backgroundColor = color?.cgColor
    }
    
    private var progressLayer = CALayer()
    
    private func changeColor(progress: Float) {
        if progress <= 0.25 {
            color = ComboColors.red
        } else if progress <= 0.5 {
            color = ComboColors.yellow
        } else if progress <= 1 {
            color = ComboColors.green
        }
    }
}
