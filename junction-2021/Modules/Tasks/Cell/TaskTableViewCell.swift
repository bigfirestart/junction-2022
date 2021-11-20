//
//  TaskTableViewCell.swift
//  junction-2021
//
//  Created by b.belotserkovtsev on 20.11.2021.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    @IBOutlet weak var wrapperView: UIView!

    enum BlockType: String {
        case text = "TEXT"
        case question = "QUESTION"
    }

    enum CheckpointState: String {
        case new = "NEW"
        case review = "IN_REVIEW"
        case accepted = "ACCEPTED"
        case declined = "DECLINED"

        var image: UIImage? {
            switch self {
            case .new:
                return nil
            case .accepted:
                return R.image.acceptedState()
            case .declined:
                return R.image.declinedState()
            case .review:
                return R.image.reviewState()
            }
        }
    }

    private var descriptionTextView: UITextView {
        let view = UITextView()
        view.isScrollEnabled = false
        view.font = .systemFont(ofSize: 15, weight: .regular)
        view.textContainer.lineFragmentPadding = 0
        view.textContainerInset = .zero
        view.isEditable = false
        return view
    }

    private lazy var textStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 12
        return view
    }()

    private lazy var questionStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 20
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Test"
        return label
    }()

    private lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 8
        return button
    }()

    private lazy var checkpointStatusImageView: UIImageView = {
        let statusImageView = UIImageView()
        statusImageView.layer.borderWidth = 1
        statusImageView.layer.borderColor = UIColor.inputBorder().cgColor
        statusImageView.backgroundColor = .white
        statusImageView.layer.cornerRadius = 20
        return statusImageView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()

        setupView()
    }

    private func setupView() {
        contentView.backgroundColor = .appBackground()
        wrapperView.addSubview(titleLabel)
        wrapperView.addSubview(textStackView)
        wrapperView.addSubview(submitButton)
        wrapperView.addSubview(questionStackView)
        wrapperView.addSubview(checkpointStatusImageView)

        checkpointStatusImageView.snp.makeConstraints { make in
            make.center.equalTo(titleLabel.snp.center)
            make.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(40)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(checkpointStatusImageView.snp.leading).inset(16)
            make.top.equalToSuperview().offset(16)
        }

        textStackView.snp.makeConstraints { make in
            make.top.equalTo(checkpointStatusImageView.snp.bottom).offset(35)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }

        questionStackView.snp.makeConstraints { make in
            make.top.equalTo(textStackView.snp.bottom).offset(35)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }

        submitButton.snp.makeConstraints { make in
            make.top.equalTo(questionStackView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(36)
            make.bottom.equalToSuperview().inset(16)
        }

        selectionStyle = .none
    }

    private func generateQuestionView(for title: String) -> UIView {
        let wrapperView = UIView()

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 15, weight: .semibold)

        let textFieldWrapperView = UIView()
        textFieldWrapperView.layer.borderWidth = 1
        textFieldWrapperView.layer.borderColor = UIColor.inputBorder().cgColor
        textFieldWrapperView.layer.cornerRadius = 10

        let textFieldView = UITextField()
        textFieldView.placeholder = "Write a comment"
        textFieldView.font = .systemFont(ofSize: 15, weight: .semibold)

//        let amountLabel = UILabel()
//        amountLabel.font = .systemFont(ofSize: 15, weight: .regular)

        wrapperView.addSubview(titleLabel)
        wrapperView.addSubview(textFieldWrapperView)
        textFieldWrapperView.addSubview(textFieldView)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        textFieldWrapperView.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        textFieldView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }

        return wrapperView
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        textStackView.subviews.forEach { view in
            view.removeFromSuperview()
        }

        questionStackView.subviews.forEach { view in
            view.removeFromSuperview()
        }

    }

    func configure(with model: TasksResponse.Task) {
        titleLabel.text = model.name

        checkpointStatusImageView.isHidden = true

        let textBlocks = model.blocks.sorted { $0.index < $1.index }.filter { BlockType(rawValue: $0.type) == .text }
        for block in textBlocks {
            let textView = descriptionTextView
            textView.text = block.content
            textStackView.addArrangedSubview(textView)
        }

        let questionBlocks = model.blocks.sorted { $0.index < $1.index }.filter { BlockType(rawValue: $0.type) == .question }
        submitButton.isHidden = questionBlocks.isEmpty
        for block in questionBlocks {
            let questionView = generateQuestionView(for: block.content)
            questionStackView.addArrangedSubview(questionView)
        }
    }

    func configure(with model: TasksResponse.Checkpoint) {
        let checkpointState = CheckpointState(rawValue: model.status)

        titleLabel.text = model.name

        checkpointStatusImageView.isHidden = false

        if let checkpointState = checkpointState, checkpointState != .new {
            checkpointStatusImageView.image = checkpointState.image
            submitButton.isEnabled = false
            submitButton.setTitleColor(.gray, for: .normal)
        } else {
            submitButton.isEnabled = true
            submitButton.setTitleColor(.black, for: .normal)
        }

        let textBlocks = model.blocks.sorted { $0.index < $1.index }.filter { BlockType(rawValue: $0.type) == .text }
        for block in textBlocks {
            let textView = descriptionTextView
            textView.text = block.content
            textStackView.addArrangedSubview(textView)
        }

        let questionBlocks = model.blocks.sorted { $0.index < $1.index }.filter { BlockType(rawValue: $0.type) == .question }
        submitButton.isHidden = questionBlocks.isEmpty
        for block in questionBlocks {
            let questionView = generateQuestionView(for: block.content)
            questionStackView.addArrangedSubview(questionView)
        }
    }
}
