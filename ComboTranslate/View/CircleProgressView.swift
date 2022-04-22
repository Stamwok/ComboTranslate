//
//  CircleProgressView.swift
//  ComboTranslate
//
//  Created by  Егор Шуляк on 20.03.22.
//

import UIKit

@IBDesignable

class CircleProgressView: UIView {
    
    @IBInspectable var color: UIColor = .gray {
        didSet {
            setNeedsDisplay()
        }
    }
    var progress: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var progressLayer = CAShapeLayer()
    private var backgroundMask = CAShapeLayer()
    
    @IBInspectable var ringWidth: CGFloat = 5.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }

    override func draw(_ rect: CGRect) {
        let circlePath = UIBezierPath(ovalIn: rect.insetBy(dx: ringWidth / 2, dy: ringWidth / 2)).cgPath
        backgroundMask.path = circlePath
        
        progressLayer.path = circlePath
        progressLayer.lineCap = .round
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = progress
        progressLayer.strokeColor = color.cgColor
    }
    
    private func setupLayers() {
        backgroundMask.lineWidth = ringWidth
        backgroundMask.fillColor = nil
        backgroundMask.strokeColor = UIColor.black.cgColor
        layer.mask = backgroundMask
        
        progressLayer.lineWidth = ringWidth
        progressLayer.fillColor = nil
        layer.addSublayer(progressLayer)
        layer.transform = CATransform3DMakeRotation(CGFloat(90 * Double.pi / 180), 0, 0, -1)
    }

}
