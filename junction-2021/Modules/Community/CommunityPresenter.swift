//
//  CommunityPresenter.swift
//  junction-2021
//
//  Created by k.lukyanov on 19.11.2021.
//

import UIKit

protocol CommunityPresenterProtocol {
	init(router: RouterProtocol, view: UIViewController)
	
	func didTapLeaderBoard()
	func battleBannerButtonTapped()
}

final class CommunityPresenter: CommunityPresenterProtocol {
	private weak var view: UIViewController?
	private let router: RouterProtocol?
	
	required init(router: RouterProtocol, view: UIViewController) {
		self.view = view
		self.router = router
	}
	
	func didTapLeaderBoard() {
		router?.moduleWantsToOpenLeaderboard() 
	}
	
	func battleBannerButtonTapped() {
		router?.moduleWantsToOpenBattleScreen()
	}
	
}
