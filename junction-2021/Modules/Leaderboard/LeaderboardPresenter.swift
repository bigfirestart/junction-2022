//
//  LeaderboardPresenter.swift
//  junction-2021
//
//  Created by k.lukyanov on 20.11.2021.
//

import UIKit

protocol LeaderboardPresenterProtocol {
	init(router: RouterProtocol, view: LeaderboardViewControllerProtocol, networkService: NetworkServiceProtocol)
	func viewDidLoadEvent()
}

final class LeaderboardPresenter: LeaderboardPresenterProtocol {
	private weak var view: LeaderboardViewControllerProtocol?
	private let router: RouterProtocol?
	private let networkService: NetworkServiceProtocol?
	
	required init(router: RouterProtocol, view: LeaderboardViewControllerProtocol, networkService: NetworkServiceProtocol) {
		self.view = view
		self.router = router
		self.networkService = networkService
	}
	
	func viewDidLoadEvent() {
		networkService?.leaderboard { [weak self] result in
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
