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
        let image: UIImage?
    }

    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var stageLabel: UILabel!
    @IBOutlet weak var stageNumberLabel: UILabel!
    @IBOutlet weak var stageImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func setupView() {
        backgroundColor = .appBackground()
        wrapperView.backgroundColor = .white

        stageLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        stageNumberLabel.font = .systemFont(ofSize: 22, weight: .bold)

        wrapperView.layer.applyFigmaShadow(color: .shadow(), x: 0, y: 4, blur: 8, spread: 0)
    }

    func configure(with model: Model) {
        stageLabel.text = model.stageName
        stageNumberLabel.text = model.stageNumber
    }
}
