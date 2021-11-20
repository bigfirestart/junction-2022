//
//  LeaderboardPresenter.swift
//  junction-2021
//
//  Created by k.lukyanov on 20.11.2021.
//

import UIKit

protocol LeaderboardPresenterProtocol {
	init(router: RouterProtocol, view: UIViewController)
}

final class LeaderboardPresenter: LeaderboardPresenterProtocol {
	private weak var view: UIViewController?
	private let router: RouterProtocol?
	
	required init(router: RouterProtocol, view: UIViewController) {
		self.view = view
		self.router = router
	}
}
