//
//  StageTableViewCell.swift
//  junction-2021
//
//  Created by b.belotserkovtsev on 19.11.2021.
//

import UIKit

class StageTableViewCell: UITableViewCell {

    struct Model {
        let stageName: String
        let stageNumber: String
        let statusImage: UIImage?
        let battleImage: UIImage?
    }

    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var stageLabel: UILabel!
    @IBOutlet weak var stageNumberLabel: UILabel!
    @IBOutlet weak var stageImageView: UIImageView!
    @IBOutlet weak var battleImageView: UIImageView!

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)

        if highlighted {
            selectionView.backgroundColor = .appBackground()
        } else {
            selectionView.backgroundColor = .white
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupView()
    }

    private func setupView() {
        backgroundColor = .appBackground()
        wrapperView.backgroundColor = .white

        stageLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        stageNumberLabel.font = .systemFont(ofSize: 22, weight: .bold)

        wrapperView.layer.applyFigmaShadow(color: .shadow(), x: 0, y: 4, blur: 8, spread: 0)

        stageImageView.layer.cornerRadius = 20
        stageImageView.backgroundColor = .white

        stageImageView.layer.borderColor = UIColor.black.cgColor
        stageImageView.layer.borderWidth = 1
        selectionStyle = .none

        selectionView.layer.cornerRadius = 10

    }

    func configure(with model: Model) {
        stageLabel.text = model.stageName
        stageNumberLabel.text = model.stageNumber
        battleImageView.image = model.battleImage
    }
}
