//
//  ActionBannerCell.swift
//  junction-2021
//
//  Created by k.lukyanov on 19.11.2021.
//

import UIKit

enum ActionBannerType {
	case battle
	case collab
}

class ActionBannerCell: UITableViewCell, PressAnimatable {
	@IBOutlet weak var wrapperView: UIView!
	@IBOutlet weak var title: UILabel!
	@IBOutlet weak var transitionButton: UIButton!
	
	public var type: ActionBannerType?
	
    override func awakeFromNib() {
        super.awakeFromNib()
		setupView()
    }

	private func setupView() {
		backgroundColor = .appBackground()
		wrapperView.layer.cornerRadius = 14
		wrapperView.layer.applyFigmaShadow(color: .shadow(), x: 0, y: 4, blur: 8, spread: 0)
		
		// common
		title.textColor = .appModal()
		title.font = .systemFont(ofSize: 16, weight: .semibold)
		transitionButton.backgroundColor = .appModal()
		transitionButton.tintColor = .appText()
		transitionButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
		transitionButton.layer.cornerRadius = 8
	
		selectionStyle = .none
	}
	
	func configureBattle() {
		title.text = "You have active battle!"
		transitionButton.setTitle("Open battle", for: .normal)
		wrapperView.backgroundColor = .appAcentOrange()
	}
	
	func configureCollab() {
		title.text = "You have one collab!"
		transitionButton.setTitle("Open collab", for: .normal)
		wrapperView.backgroundColor = .appAcentBlue()
	}
    
}
