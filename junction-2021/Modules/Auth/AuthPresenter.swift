//
//  AuthPresenter.swift
//  junction-2021
//
//  Created by k.lukyanov on 19.11.2021.
//

import UIKit

protocol AuthPresenterProtocol {
	func login(username: String, password: String)
}

final class AuthPresenter: AuthPresenterProtocol {
	private weak var view: AuthViewController?
	private let router: RouterProtocol
	private let network: NetworkServiceProtocol
    private let tokenManager: TokenManagerProtocol
	
    init(view: UIViewController, router: RouterProtocol, network: NetworkServiceProtocol, tokenManager: TokenManagerProtocol) {
		self.view = view as? AuthViewController
		self.router = router
		self.network = network
        self.tokenManager = tokenManager
	}
	
	func login(username: String, password: String) {
		let model = AuthModel(username: username, password: password)
		network.auth(authModel: model, complition: { [weak self] result in
            guard let self = self else { return }
			switch result {
			case .success(let token):
                self.tokenManager.set(token: token)
                self.router.moduleWantsToOpenAuthorized()
			case .failure(let error):
				self.processIncorrectLogin(message: error.localizedDescription)
			}
		})
	}

	func processIncorrectLogin(message: String) {
		view?.invalidLogin(message: message)
	}
}
