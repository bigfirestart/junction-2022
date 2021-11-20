//
//  LeaderBoardWithActionCell.swift
//  junction-2021
//
//  Created by k.lukyanov on 20.11.2021.
//

import UIKit

enum BackgroundColor {
	case orange
	case blue
	case grey
}

class LeaderBoardCell: UITableViewCell {
	@IBOutlet weak var wrapper: UIView!
	@IBOutlet weak var numberLabel: UILabel!
	@IBOutlet weak var commandNameLabel: UILabel!
	@IBOutlet weak var pointsLabel: UILabel!
	@IBOutlet weak var battleButton: UIButton!
	@IBOutlet weak var higlihtedBackgroundView: UIView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		setupView()
	}
	
	private func setupView() {
		backgroundColor = .appBackground()
		layer.cornerRadius = 20
		selectionStyle = .none
		
		commandNameLabel.text = "Team name"
		commandNameLabel.font = .systemFont(ofSize: 15, weight: .semibold)

		pointsLabel.text = "12.5"
		pointsLabel.font = .systemFont(ofSize: 15, weight: .semibold)
		
		numberLabel.font = .systemFont(ofSize: 22, weight: .bold)
		
		if battleButton != nil {
			battleButton.tintColor = .appModal()
			battleButton.backgroundColor = .appAcentOrange()
//			battleButton.setRounded()
		}
		
		higlihtedBackgroundView.backgroundColor = .appModal()
	}
	
	func asBanner() {
		wrapper.layer.cornerRadius = 14
	}
	
	func hideButton() {
		if battleButton != nil {
			battleButton.isHidden = true
		}
	}
	
	func colorBackground(with color: BackgroundColor) {
//		switch color {
//		case .orange:
//			higlihtedBackgroundView.backgroundColor = .appAcentOrange()
//		case .blue:
//			higlihtedBackgroundView.backgroundColor = .appAcentBlue()
//			hideButton()
//		case .grey:
//			higlihtedBackgroundView.backgroundColor = .appDarkGrey()
//			hideButton()
//		}
//		
//		higlihtedBackgroundView.layer.cornerRadius = 10
//		numberLabel.textColor = .appModal()
//		numberLabel.backgroundColor = .appAcentOrange()
//		pointsLabel.textColor = .appModal()
//		commandNameLabel.textColor = .appModal()
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		higlihtedBackgroundView.backgroundColor = .appModal()
		numberLabel.textColor = .appText()
		pointsLabel.textColor = .appText()
		commandNameLabel.textColor = .appText()
		battleButton.isHidden = false
	}
}
