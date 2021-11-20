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
		static let teamReuseId = String(describing: TeamTableViewCell.self)
		static let titleReuseId = String(describing: TitileCell.self)
		static let topLeaderBoardReuseId = String(describing: LeaderBoardCell.self)
		static let tableButton = String(describing: ButtonCell.self)
	}
	
	private lazy var tableView: UITableView = {
		let table = UITableView()
		table.delegate = self
		table.dataSource = self
		table.register(UINib(resource: R.nib.actionBannerCell), forCellReuseIdentifier: Constants.bannerReuseId)
		table.register(SpaceCell.self, forCellReuseIdentifier: Constants.spaceReuseId)
		table.register(UINib(resource: R.nib.teamTableViewCell), forCellReuseIdentifier: Constants.teamReuseId)
		table.register(TitileCell.self, forCellReuseIdentifier: Constants.titleReuseId)
		table.register(UINib(resource: R.nib.buttonCell), forCellReuseIdentifier: Constants.tableButton)
		table.register(UINib(resource: R.nib.leaderBoardCell), forCellReuseIdentifier: Constants.topLeaderBoardReuseId)
		
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
	func numberOfSections(in tableView: UITableView) -> Int {
		2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 4
		}
		if section == 1 {
			return 11
		}
		return 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let section = indexPath.section
		if section == 0 {
			return bannerSection(cellForRowAt: indexPath)
		}
		if section == 1 {
			return leaderBoardSection(cellForRowAt: indexPath)
		}
		
		return UITableViewCell()
	}
	
	func bannerSection(cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: Constants.bannerReuseId, for: indexPath) as? ActionBannerCell
			cell?.configureBattle()
			cell?.transitionButton.addTarget(self, action: #selector(battleBannerButtonTapped), for: .touchUpInside)
			return cell ?? UITableViewCell()
		}
		
		if indexPath.row == 1 {
			return space(cellForRowAt: indexPath, height: 20)
		}
		
		if indexPath.row == 2 {
			let cell = tableView.dequeueReusableCell(withIdentifier: Constants.bannerReuseId, for: indexPath) as? ActionBannerCell
			cell?.configureCollab()
			return cell ?? UITableViewCell()
		}
		
		if indexPath.row == 3 {
			return space(cellForRowAt: indexPath, height: 30)
		}
		
		if indexPath.row == 4 {
			return tableView.dequeueReusableCell(withIdentifier: Constants.teamReuseId, for: indexPath)
		}
		return UITableViewCell()
	}
	
	func leaderBoardSection(cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			return tableView.dequeueReusableCell(withIdentifier: Constants.titleReuseId, for: indexPath)
		}
		
		if indexPath.row == 1 {
			return space(cellForRowAt: indexPath, height: 10)
		}
		
		if indexPath.row == 2 {
			let leaderBoardBanner = tableView.dequeueReusableCell(withIdentifier: Constants.topLeaderBoardReuseId, for: indexPath) as? LeaderBoardCell
			leaderBoardBanner?.asBanner()
			leaderBoardBanner?.commandLogo.image = AvatarFactory.getUserAvatar()
			return leaderBoardBanner ?? UITableViewCell()
		}
		
		if indexPath.row == 3 {
			return space(cellForRowAt: indexPath, height: 30)
		}
		
		if indexPath.row > 3 && indexPath.row < 9 {
			let cell = tableView.dequeueReusableCell(withIdentifier: Constants.topLeaderBoardReuseId, for: indexPath) as? LeaderBoardCell
			cell?.commandLogo.image = AvatarFactory.getRandomAvatar()
			return cell ?? UITableViewCell()
		}
		
		if indexPath.row == 9 {
			let buttonCell = tableView.dequeueReusableCell(withIdentifier: Constants.tableButton, for: indexPath) as? ButtonCell
			buttonCell?.withLabel(text: "Show more")
			buttonCell?.button.addTarget(self, action: #selector(leaderButtonTapped), for: .touchDown)
			return buttonCell ?? UITableViewCell()
		}
		
		if indexPath.row == 10 {
			return space(cellForRowAt: indexPath, height: 100)
		}
		
		return UITableViewCell()
	}
	
	func space(cellForRowAt indexPath: IndexPath, height: Int) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: Constants.spaceReuseId, for: indexPath) as? SpaceCell
		cell?.withHeight(height: CGFloat(height))
		return cell ?? UITableViewCell()
	}
}

// taps
extension CommunityViewController {
	@objc
	func leaderButtonTapped() {
		presenter?.didTapLeaderBoard()
	}
	
	@objc
	func battleBannerButtonTapped() {
		presenter?.battleBannerButtonTapped()
	}
}
