//
//  TitileCell.swift
//  junction-2021
//
//  Created by k.lukyanov on 20.11.2021.
//
import UIKit

class TitileCell: UITableViewCell {
	let title = UILabel()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public func setupView() {
		heightAnchor.constraint(equalToConstant: 100).isActive = true
		backgroundColor = .appBackground()
		selectionStyle = .none
		
		contentView.addSubview(title)
		title.text = "Leaderboard"
		title.font = .systemFont(ofSize: 22, weight: .semibold)
		
		title.snp.makeConstraints { (make) -> Void in
			make.directionalMargins.equalToSuperview()
			make.leading.equalTo(contentView).offset(16)
		}
	}
}
