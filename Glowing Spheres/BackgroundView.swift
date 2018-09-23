//
//  BackgroundView.swift
//  Glowing Spheres
//
//  Created by martin on 23.09.18.
//  Copyright © 2018 Martin List. All rights reserved.
//

import UIKit

class BackgroundView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        var insets: UIEdgeInsets
        
        if #available(iOS 11.0, *) {
            insets = safeAreaInsets
        }
        else {
            insets = layoutMargins
        }
        
        context.setLineWidth(2.0)
        context.setStrokeColor(UIColor.white.cgColor)
        context.setShadow(offset: CGSize(width: 0.0, height: 0.0), blur: 5.0, color: UIColor.cyan.cgColor)

        var startingPoint = CGPoint(x: frame.width, y: frame.origin.y + 25 + insets.top)
        var endingPoint = CGPoint(x: frame.width * 1/3, y: frame.origin.y + 25 + insets.top)
        context.move(to: startingPoint)
        context.addLine(to: endingPoint)
        context.strokePath()
        
        startingPoint = CGPoint(x: 0, y: frame.size.height - 25 - insets.bottom)
        endingPoint = CGPoint(x: frame.width * 2/3, y: frame.size.height - 25 - insets.bottom)
        context.move(to: startingPoint)
        context.addLine(to: endingPoint)
        context.strokePath()
        
    }

}
