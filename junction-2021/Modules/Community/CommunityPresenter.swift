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
		network?.leaderboard { [weak self] result in
			switch result {
			case .success(let data):
				print(data)
				self?.view?.setState(with: .data(data))
			case .failure(let error):
				print(error)
			}
		}
	}
}
