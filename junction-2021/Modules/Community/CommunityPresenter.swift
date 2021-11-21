//
//  CommunityPresenter.swift
//  junction-2021
//
//  Created by k.lukyanov on 19.11.2021.
//

import UIKit

protocol CommunityPresenterProtocol {
	init(router: RouterProtocol, view: CommunityViewControllerProtocol, networkService: NetworkServiceProtocol)
	
	func didTapLeaderBoard()
	func battleBannerButtonTapped()
	func viewDidLoadEvent()
}

final class CommunityPresenter: CommunityPresenterProtocol {
	private weak var view: CommunityViewControllerProtocol?
	private let router: RouterProtocol?
	private let network: NetworkServiceProtocol?
	
	required init(router: RouterProtocol, view: CommunityViewControllerProtocol, networkService: NetworkServiceProtocol) {
		self.view = view
		self.router = router
		self.network = networkService
	}
	
	func didTapLeaderBoard() {
		router?.moduleWantsToOpenLeaderboard() 
	}
	
	func battleBannerButtonTapped() {
		router?.moduleWantsToOpenBattleScreen()
	}
	
	func viewDidLoadEvent() {
		network?.team { result in
			switch result {
			case .success(let team):
				self.network?.leaderboard { [weak self] result in
					switch result {
					case .success(let leaderBoard):
						let ourTeam = leaderBoard.first(where: {$0.id == team.id})
						let position = leaderBoard.firstIndex(where: {$0.id == team.id})
						
						let view = self?.view as? CommunityViewController
						view?.userInLeaderboard = ourTeam
						view?.userPositionInLeaderboard = position ?? 0 + 1
						self?.view?.setState(with: .data(leaderBoard))
					case .failure(let error):
						print(error)
					}
				}
			case .failure:
				print("F")
			}
		}
	}
	
	func getCurrentTeam() {
		
	}
}
