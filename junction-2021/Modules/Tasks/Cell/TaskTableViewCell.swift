//
//  TaskTableViewCell.swift
//  junction-2021
//
//  Created by b.belotserkovtsev on 20.11.2021.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    struct Model {
        let title: String
        let delta: String
        let task: String
        let questionTitle: String
        let statusIcon: UIImage
    }

    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pointsDeltaLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet weak var questionStatusIconImageView: UIImageView!
    @IBOutlet weak var textFieldWrapperView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var submitButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupView()
    }

    func configure(with: Model) {

    }

    private func setupView() {
        wrapperView.backgroundColor = .white
        backgroundColor = .appBackground()
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        pointsDeltaLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        pointsLabel.font = .systemFont(ofSize: 12, weight: .regular)
        pointsLabel.textColor = .gray
        pointsLabel.text = "points"
        descriptionTextView.font = .systemFont(ofSize: 15, weight: .regular)
        questionTitleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        questionStatusIconImageView.backgroundColor = .white
        questionStatusIconImageView.layer.borderWidth = 1
        questionStatusIconImageView.layer.borderColor = UIColor.black.cgColor
        questionStatusIconImageView.layer.cornerRadius = 20

        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = UIColor.black.cgColor
        submitButton.layer.cornerRadius = 8

        textFieldWrapperView.layer.cornerRadius = 10
        textFieldWrapperView.layer.borderWidth = 1
        textFieldWrapperView.layer.borderColor = UIColor.gray.cgColor

        selectionStyle = .none
    }
}
