//
//  TeamTableViewCell.swift
//  junction-2021
//
//  Created by b.belotserkovtsev on 19.11.2021.
//

import UIKit

class TeamTableViewCell: UITableViewCell, PressAnimatable {

    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var teamNameLabel: UILabel!
    @IBOutlet private weak var pointsCountLabel: UILabel!
    @IBOutlet private weak var pointsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupView()
    }

    private func setupView() {
        backgroundColor = .appBackground()
        wrapperView.backgroundColor = .white
        wrapperView.layer.cornerRadius = 14
        wrapperView.layer.applyFigmaShadow(color: .shadow(), x: 0, y: 4, blur: 8, spread: 0)

        iconImageView.backgroundColor = .gray

        teamNameLabel.text = "Team name"
        teamNameLabel.font = .systemFont(ofSize: 15, weight: .semibold)

        pointsCountLabel.text = "8.5"
        pointsCountLabel.font = .systemFont(ofSize: 15, weight: .semibold)

        pointsLabel.text = "points"
        pointsLabel.font = .systemFont(ofSize: 12, weight: .light)
        selectionStyle = .none

    }
    
}
