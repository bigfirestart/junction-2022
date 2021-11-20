//
//  RoundedHeader.swift
//  junction-2021
//
//  Created by b.belotserkovtsev on 19.11.2021.
//

import UIKit

class TitleWithRoundTopHeader: UITableViewHeaderFooterView {

    struct Model {
        let titleColor: UIColor
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private lazy var bottomExtendedCellView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        bottomExtendedCellView.roundCorners(corners: [.topLeft, .topRight], radius: 14)

    }

    func setupView() {
        addSubview(titleLabel)
        addSubview(bottomExtendedCellView)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(43)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }

        bottomExtendedCellView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
            make.height.equalTo(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }

        titleLabel.text = "Stages"
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        contentView.backgroundColor = .appBackground()
    }

    func configure(with model: Model) {
        titleLabel.textColor = model.titleColor
    }
}
