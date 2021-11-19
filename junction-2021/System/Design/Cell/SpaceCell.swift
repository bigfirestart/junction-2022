//
//  SpaceCell.swift
//  junction-2021
//
//  Created by k.lukyanov on 19.11.2021.
//
import UIKit

class SpaceCell: UITableViewCell {
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public func setupView() {
		heightAnchor.constraint(equalToConstant: 100)
		backgroundColor = .appBackground()
		selectionStyle = .none
	}
}
