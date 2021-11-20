//
//  LoadingCell.swift
//  junction-2021
//
//  Created by b.belotserkovtsev on 20.11.2021.
//

import UIKit

class LoadingCell: UITableViewCell {
    private lazy var loader: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.startAnimating()
        return indicator
    }()

    private lazy var wrapperView: UIView = {
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

    private func setupView() {
        contentView.backgroundColor = .appBackground()
        contentView.addSubview(wrapperView)
        wrapperView.addSubview(loader)

        wrapperView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }

        loader.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview()
        }
    }
}
