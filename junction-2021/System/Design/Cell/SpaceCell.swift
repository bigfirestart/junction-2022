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
		backgroundColor = .appBackground()
		selectionStyle = .none
	}
	
	public func withHeight(height: CGFloat) {
		heightAnchor.constraint(equalToConstant: height).isActive = true
	}
}
