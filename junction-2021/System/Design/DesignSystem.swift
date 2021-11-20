//
//  DesignSystem.swift
//  junction-2021
//
//  Created by k.lukyanov on 19.11.2021.
//

import UIKit

final class Button: UIButton {
	init() {
		super.init(frame: .zero)
		backgroundColor = .appModal()
		layer.cornerRadius = 8
		layer.borderWidth = 1
		layer.borderColor = UIColor.appText().cgColor
		setTitleColor(.appText(), for: .normal)
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

final class BackgroundMount: UIView {
	init() {
		super.init(frame: .zero)
		backgroundColor = .appModal()
		layer.cornerRadius = 14
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

final class TextField: UITextField {
	init() {
		super.init(frame: .zero)
		backgroundColor = .appModal()
		layer.cornerRadius = 10
		layer.borderWidth = 1
//		layer.borderColor = UIColor.lightGray().cgColor

		// left space
		let spacerView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
		self.leftViewMode = .always
		self.leftView = spacerView
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}


// rewrite Cell Delete

extension UITableViewCell.EditingStyle {
	
}
