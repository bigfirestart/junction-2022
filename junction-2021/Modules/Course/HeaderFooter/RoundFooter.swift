//
//  RoundFooter.swift
//  junction-2021
//
//  Created by b.belotserkovtsev on 19.11.2021.
//

import UIKit

class RoundFooter: UITableViewHeaderFooterView {
    private lazy var bottomRoundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        bottomRoundView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 14)
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupView()
    }

    private func setupView() {
        addSubview(bottomRoundView)

        bottomRoundView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(16)
        }
    }
}
