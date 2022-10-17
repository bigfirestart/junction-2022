//
//  CommunityViewController.swift
//  junction-2021
//
//  Created by k.lukyanov on 19.11.2021.
//

import UIKit

protocol CommunityViewControllerProtocol: AnyObject {
	func setState(with: CommunityViewController.State)
    func setBattleState(with: CommunityViewController.BattleState)
    func setCollabState(with: CommunityViewController.CollabState)
}

final class CommunityViewController: UIViewController {
	var presenter: CommunityPresenterProtocol?
	
	private enum Constants {
		static let bannerReuseId = String(describing: ActionBannerCell.self)
		static let spaceReuseId = String(describing: SpaceCell.self)
		static let teamReuseId = String(describing: TeamTableViewCell.self)
		static let titleReuseId = String(describing: TitileCell.self)
		static let topLeaderBoardReuseId = String(describing: LeaderBoardCell.self)
		static let tableButton = String(describing: ButtonCell.self)
		static let loaderReuseId = String(describing: LoadingCell.self)
	}
	
	enum State {
		case loading
		case data([LeaderboardResponse])
	}
    
    var state: State = .loading {
        didSet {
            tableView.reloadData()
        }
    }
    
    enum BattleState {
        case loading
        case data(Battle)
    }
    
    var battleState: BattleState = .loading {
        didSet {
            tableView.reloadData()
        }
    }
    
    enum CollabState {
        case loading
        case data(Collab)
    }
    
    var collabState: CollabState = .loading {
        didSet {
            tableView.reloadData()
        }
    }
	
	var userInLeaderboard: LeaderboardResponse?
	
	var userPositionInLeaderboard: Int?
	
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
		table.register(LoadingCell.self, forCellReuseIdentifier: Constants.loaderReuseId)
		
		return table
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .appBackground()
		
		setupTable()
		presenter?.viewDidLoadEvent()
        presenter?.loadActiveEvents()
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
        tableView.rowHeight = UITableView.automaticDimension
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
		3
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 4
		}
		if section == 1 {
			return 4
		}
		if section == 2 {
			switch state {
			case .data(let leaderboard):
				return 2 + leaderboard.count
			case .loading:
				return 2
			}
		}
		return 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let section = indexPath.section
		if section == 0 {
			return bannerSection(cellForRowAt: indexPath)
		}
		if section == 1 {
			return leaderBoardPre(cellForRowAt: indexPath)
		}
		if section == 2 {
			return leaderBoard(cellForRowAt: indexPath)
		}
		
		return UITableViewCell()
	}
	
	func bannerSection(cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
            switch battleState {
            case .loading:
                return space(cellForRowAt: indexPath, height: 1)
            case .data:
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.bannerReuseId, for: indexPath) as? ActionBannerCell
                cell?.configureBattle()
                cell?.transitionButton.addTarget(self, action: #selector(battleBannerButtonTapped), for: .touchUpInside)
                return cell ?? UITableViewCell()
            }
		}
		
		if indexPath.row == 1 {
			return space(cellForRowAt: indexPath, height: 20)
		}
		
		if indexPath.row == 2 {
            switch collabState {
            case .loading:
                return space(cellForRowAt: indexPath, height: 1)
            case .data:
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.bannerReuseId, for: indexPath) as? ActionBannerCell
                cell?.configureCollab()
                cell?.transitionButton.addTarget(self, action: #selector(collabBannerButtonTapped), for: .touchUpInside)
                return cell ?? UITableViewCell()
            }
		}
		
		if indexPath.row == 3 {
			return space(cellForRowAt: indexPath, height: 30)
		}

		return UITableViewCell()
	}
	
	func leaderBoardPre(cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			return tableView.dequeueReusableCell(withIdentifier: Constants.titleReuseId, for: indexPath)
		}
		
		if indexPath.row == 1 {
			return space(cellForRowAt: indexPath, height: 10)
		}
		
		if indexPath.row == 2 {
			if let team = userInLeaderboard,
			   let index = userPositionInLeaderboard {
				let leaderBoardBanner = tableView.dequeueReusableCell(withIdentifier: Constants.topLeaderBoardReuseId, for: indexPath) as? LeaderBoardCell
				leaderBoardBanner?.asBanner()
				leaderBoardBanner?.commandLogo.image = AvatarFactory.getUserAvatar()
				leaderBoardBanner?.configure(model: team, index: index + 1)
				return leaderBoardBanner ?? UITableViewCell()
			} else {
				tableView.dequeueReusableCell(withIdentifier: Constants.loaderReuseId, for: indexPath)
			}
		
		}
		
		if indexPath.row == 3 {
			return space(cellForRowAt: indexPath, height: 30)
		}
		return UITableViewCell()
	}
	
	func leaderBoard(cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch state {
		case .data(let leaderboard):
			if indexPath.row < leaderboard.count {
				// leaderboard
				guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.topLeaderBoardReuseId, for: indexPath) as? LeaderBoardCell else {
					return UITableViewCell()
				}

				cell.configure(model: leaderboard[indexPath.row], index: indexPath.row + 1)
				return cell
			}
			if indexPath.row == leaderboard.count {
				let buttonCell = tableView.dequeueReusableCell(withIdentifier: Constants.tableButton, for: indexPath) as? ButtonCell
				buttonCell?.withLabel(text: "Show more")
				buttonCell?.button.addTarget(self, action: #selector(leaderButtonTapped), for: .touchDown)
				return buttonCell ?? UITableViewCell()
			}
			if indexPath.row == leaderboard.count + 1 {
				return space(cellForRowAt: indexPath, height: 100)
			}
		case .loading:
			// 3 cells
			if indexPath.row == 0 {
				return tableView.dequeueReusableCell(withIdentifier: Constants.loaderReuseId, for: indexPath)
			}
			
			if indexPath.row == 1 {
				let buttonCell = tableView.dequeueReusableCell(withIdentifier: Constants.tableButton, for: indexPath) as? ButtonCell
				buttonCell?.withLabel(text: "Show more")
				buttonCell?.button.addTarget(self, action: #selector(leaderButtonTapped), for: .touchDown)
				return buttonCell ?? UITableViewCell()
			}
			if indexPath.row == 2 {
				return space(cellForRowAt: indexPath, height: 100)
			}
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

    @objc func collabBannerButtonTapped() {
        let vc = CollabViewController(nib: R.nib.collabViewController)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CommunityViewController: CommunityViewControllerProtocol {
	func setState(with state: State) {
		self.state = state
	}
    
    func setBattleState(with state: BattleState) {
        self.battleState = state
    }
    
    func setCollabState(with state: CollabState) {
        self.collabState = state
    }
}
