//
//  UIView+roundCorner.swift
//  junction-2021
//
//  Created by b.belotserkovtsev on 19.11.2021.
//

import UIKit

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UIView {
   func setRounded() {
	let radius = self.frame.width / 2
	  self.layer.cornerRadius = radius
	  self.layer.masksToBounds = true
   }
}
