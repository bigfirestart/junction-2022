//
//  Navigation+Icon.swift
//  junction-2021
//
//  Created by k.lukyanov on 20.11.2021.
//

import UIKit

extension UINavigationController {
	func makeAppCustomNavigationBar() {
		let backImage = R.image.navBack()
		navigationBar.backIndicatorImage = backImage
		navigationBar.backIndicatorTransitionMaskImage = backImage
	}
	open override func viewWillLayoutSubviews() {
		navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
	}
}
