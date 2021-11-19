//
//  PressAnimatable.swift
//  junction-2021
//
//  Created by b.belotserkovtsev on 19.11.2021.
//

import UIKit

protocol PressAnimatable {
    var wrapperView: UIView! { get }

    func animateTap()
    func animateRelease()
}

extension PressAnimatable {
    func animateTap() {
        UIView.animate(withDuration: 0.2) {
            self.wrapperView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }

    func animateRelease() {
        UIView.animate(withDuration: 0.2) {
            self.wrapperView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
}
