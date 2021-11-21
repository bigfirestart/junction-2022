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
	@IBOutlet weak var higlihtedBackgroundView: UIView!
	@IBOutlet weak var commandLogo: UIImageView!
	
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
		
		commandNameLabel.font = .systemFont(ofSize: 15, weight: .semibold)

		pointsLabel.font = .systemFont(ofSize: 15, weight: .semibold)
		
		numberLabel.font = .systemFont(ofSize: 22, weight: .bold)
		
		higlihtedBackgroundView.backgroundColor = .appModal()
		commandLogo.image = AvatarFactory.getRandomAvatar()
		commandLogo.setRounded()
	}
	
	func asBanner() {
		wrapper.layer.cornerRadius = 14
	}
	
	func configure(model: LeaderboardResponse, index: Int) {
		self.numberLabel.text = String(index) + "."
		self.commandNameLabel.text = model.name
		let point: Float = Float(model.points) / Float(10)
		self.pointsLabel.text = String(format: "%.1f", point)
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		higlihtedBackgroundView.backgroundColor = .appModal()
		numberLabel.textColor = .appText()
		pointsLabel.textColor = .appText()
		commandNameLabel.textColor = .appText()
	}
}
