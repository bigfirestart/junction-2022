//
//  ButtonCell.swift
//  junction-2021
//
//  Created by k.lukyanov on 20.11.2021.
//

import UIKit

protocol TouchDelegate {
	func tapped()
}

class ButtonCell: UITableViewCell {

	@IBOutlet weak var wrapper: UIView!
	@IBOutlet weak var button: UIButton!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
	
	private func setupView() {
		backgroundColor = .appBackground()
		selectionStyle = .none
		
		wrapper.backgroundColor = .appModal()
		button.layer.borderWidth = 1
		button.layer.borderColor = UIColor.appText().cgColor
		button.layer.cornerRadius = 8
		button.setTitleColor(.appText(), for: .normal)
	}
	
	func withLabel(text: String) {
		button.setTitle(text, for: .normal)
	}
}
