//
//  LeaderBoardWithActionCell.swift
//  junction-2021
//
//  Created by k.lukyanov on 20.11.2021.
//

import UIKit

class LeaderBoardWithActionCell: UITableViewCell {
	@IBOutlet weak var wrapper: UIView!
	@IBOutlet weak var numberLabel: UILabel!
	@IBOutlet weak var commandNameLabel: UILabel!
	@IBOutlet weak var pointsLabel: UILabel!
	@IBOutlet weak var battleButton: UIButton!
	
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
	}
}
