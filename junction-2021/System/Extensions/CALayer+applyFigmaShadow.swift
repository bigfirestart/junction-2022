//
//  CALayer+applyFigmaShadow.swift
//  junction-2021
//
//  Created by b.belotserkovtsev on 19.11.2021.
//

import UIKit

extension CALayer {
    func applyFigmaShadow(color: UIColor, x: CGFloat, y: CGFloat, blur: CGFloat, spread: CGFloat) {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = 1
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
