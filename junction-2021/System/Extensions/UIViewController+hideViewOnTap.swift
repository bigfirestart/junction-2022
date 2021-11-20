//
//  UIViewController+hideViewOnTap.swift
//  junction-2021
//
//  Created by b.belotserkovtsev on 20.11.2021.
//

import UIKit

extension UIViewController {
    /// Call this once to dismiss open keyboards by tapping anywhere in the view controller
    func hideKeyboardOnTap() {
        view.addGestureRecognizer(endEditingRecognizer())
        navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }

    /// Dismisses the keyboard from self.view
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
}
