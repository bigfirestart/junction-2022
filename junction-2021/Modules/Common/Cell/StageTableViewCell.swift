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
        let status: String
        let isInBattle: Bool
        let description: String
    }

    enum State: String {
        case new = "NEW"
        case review = "IN_REVIEW"
        case accepted = "ACCEPTED"
        case declined = "DECLINED"

        var image: UIImage? {
            switch self {
            case .new:
                return nil
            case .accepted:
                return UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
            case .declined:
                return R.image.declinedState()
            case .review:
                return R.image.reviewState()
            }
        }
    }

    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var stageLabel: UILabel!
    @IBOutlet weak var stageImageView: UIImageView!
    @IBOutlet weak var battleImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!

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

        wrapperView.layer.applyFigmaShadow(color: .shadow(), x: 0, y: 4, blur: 8, spread: 0)

        stageImageView.layer.cornerRadius = 20
        stageImageView.backgroundColor = .white

        stageImageView.layer.borderColor = UIColor.inputBorder().cgColor
        stageImageView.layer.borderWidth = 1
        selectionStyle = .none

        selectionView.layer.cornerRadius = 10

    }

    func configure(with model: Model) {
        stageLabel.text = model.stageName
        descriptionLabel.text = model.description
        descriptionLabel.textColor = .secondaryText()

        if let state = State(rawValue: model.status) {
            stageImageView.isHidden = false
            stageImageView.image = state.image
        } else {
            stageImageView.isHidden = true
        }

        if model.isInBattle {
            battleImageView.isHidden = false
            battleImageView.image = R.image.swordsIcon()
        } else {
            battleImageView.isHidden = true
        }
    }
}
