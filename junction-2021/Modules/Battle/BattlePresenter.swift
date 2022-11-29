//
//  BattlePresenter.swift
//  junction-2021
//
//  Created by k.lukyanov on 20.11.2021.
//

import UIKit

protocol BattlePresenterProtocol {
	init(progress: BattleProgress, router: RouterProtocol, view: BattleViewController, networkService: NetworkServiceProtocol)
}

final class BattlePresenter: BattlePresenterProtocol {
	private weak var view: BattleViewController?
	private let router: RouterProtocol?
    private let networkService: NetworkServiceProtocol?
	
    required init(progress: BattleProgress, router: RouterProtocol, view: BattleViewController, networkService: NetworkServiceProtocol) {
		self.view = view
		self.router = router
        self.networkService = networkService
        view.progress = progress
	}
}
