//
//  SpacingWithRoundTopCell.swift
//  junction-2021
//
//  Created by b.belotserkovtsev on 20.11.2021.
//

import UIKit

class SpacingWithRoundTopBottomCell: UITableViewCell {
    private lazy var spacingView: UIView = {
        let view = UIView()
        view.backgroundColor = .appBackground()
        return view
    }()

    private lazy var roundedTopView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private lazy var roundedBottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

//        roundedTopView.roundCorners(corners: [.topLeft, .topRight], radius: 14)
//        roundedBottomView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 14)
    }

    private func setupView() {
        contentView.addSubview(spacingView)
        contentView.addSubview(roundedTopView)
        contentView.addSubview(roundedBottomView)

        contentView.backgroundColor = .appBackground()

        roundedTopView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
            make.height.equalTo(16)
        }

        roundedBottomView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.height.equalTo(16)
        }

        spacingView.snp.makeConstraints { make in
            make.top.equalTo(roundedBottomView.snp.bottom)
            make.bottom.equalTo(roundedTopView.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(15)
        }
    }
}
