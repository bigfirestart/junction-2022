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
    func loadActiveEvents()
}

final class CommunityPresenter: CommunityPresenterProtocol {
	private weak var view: CommunityViewControllerProtocol?
	private let router: RouterProtocol?
	private let network: NetworkServiceProtocol?
    private var activeBattle: Battle?
	
	required init(router: RouterProtocol, view: CommunityViewControllerProtocol, networkService: NetworkServiceProtocol) {
		self.view = view
		self.router = router
		self.network = networkService
	}
	
	func didTapLeaderBoard() {
		router?.moduleWantsToOpenLeaderboard() 
	}
	
	func battleBannerButtonTapped() {
        if let activeBattle = self.activeBattle {
            network?.getBattleProgress(battleId: activeBattle.id) { result in
                switch result{
                case .success(let data):
                    self.router?.moduleWantsToOpenBattleScreen(with: data)
                case .failure:
                    print("F")
                }
            }
        }
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
						self?.view?.setState(with: .data(Array(leaderBoard[0..<5])))
					case .failure(let error):
						print(error)
					}
				}
			case .failure:
				print("F")
			}
		}
	}
	
    func loadActiveEvents() {
        network?.getActiveBattle { [weak self] result in
            switch result {
            case .success(let data):
                print(data)
                self?.activeBattle = data
                self?.view?.setBattleState(with: .data(data))
            case .failure(let error):
                print(error)
            }
        }
        
        network?.getActiveCollab { [weak self] result in
            switch result {
            case .success(let data):
                print(data)
                self?.view?.setCollabState(with: .data(data))
            case .failure(let error):
                print(error)
            }
        }
    }
}
