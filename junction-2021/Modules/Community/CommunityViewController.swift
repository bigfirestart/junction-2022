//
//  CommunityViewController.swift
//  junction-2021
//
//  Created by k.lukyanov on 19.11.2021.
//

import UIKit

final class CommunityViewController: UIViewController {
	var presenter: CommunityPresenterProtocol?
	
	private enum Constants {
		static let bannerReuseId = String(describing: ActionBannerCell.self)
		static let spaceReuseId = String(describing: SpaceCell.self)
	}
	
	private lazy var tableView: UITableView = {
		let table = UITableView()
		table.delegate = self
		table.dataSource = self
		table.register(UINib(resource: R.nib.actionBannerCell), forCellReuseIdentifier: Constants.bannerReuseId)
		table.register(SpaceCell.self, forCellReuseIdentifier: Constants.spaceReuseId)
		return table
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .appBackground()
		
		setupTable()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		title = "Community"
		
		DispatchQueue.main.async { [weak self] in
			self?.navigationController?.navigationBar.sizeToFit()
		}
	}
	
	private func setupTable() {
		view.addSubview(tableView)
		tableView.backgroundColor = .appBackground()
		tableView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}

		tableView.separatorStyle = .none
		tableView.contentInset = UIEdgeInsets(top: 45, left: 0, bottom: 0, right: 0)
	}
	
}

extension CommunityViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as? TeamTableViewCell
		cell?.animateTap()
	}

	func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as? TeamTableViewCell
		cell?.animateRelease()
	}
}

extension CommunityViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		3
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: Constants.bannerReuseId, for: indexPath) as? ActionBannerCell
			cell?.configureBattle()
			return cell ?? UITableViewCell()
		}
		
		if indexPath.row == 1 {
			return tableView.dequeueReusableCell(withIdentifier: Constants.spaceReuseId, for: indexPath)
		}
		
		if indexPath.row == 2 {
			let cell = tableView.dequeueReusableCell(withIdentifier: Constants.bannerReuseId, for: indexPath) as? ActionBannerCell
			cell?.configureCollab()
			return cell ?? UITableViewCell()
		}
		
		return UITableViewCell()
	}
}
