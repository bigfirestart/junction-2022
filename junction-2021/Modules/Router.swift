//
//  Router.swift
//  junction-2021
//
//  Created by k.lukyanov on 19.11.2021.
//
import UIKit
import Swinject

protocol RouterProtocol {
    func moduleWantsToOpenAuth()
    func moduleWantsToOpenAuthorized()
    func moduleWantsToOpenTasks(with: Int)
	func moduleWantsToOpenLeaderboard()
	func moduleWantsToOpenBattleScreen()
}

final class Router: RouterProtocol {
    
    private let window: UIWindow?
    private var courseNavigationController: UINavigationController?
	private var communityNavigationController: UINavigationController?
    private let container: Container
    private let tokenManager: TokenManagerProtocol
    private let assembly: AssemblyProtocol

    init(container: Container, window: UIWindow?) {
        self.container = container
        self.window = window
        self.assembly = container.resolve()
        self.tokenManager = container.resolve()
    }

    func moduleWantsToOpenAuth() {
        let authVC = assembly.createAuthScreen(router: self, container: container)
        window?.rootViewController = authVC
    }

    func moduleWantsToOpenAuthorized() {
        let modules = assembly.createAuthorizedScreens(router: self, container: container)
        window?.rootViewController = modules.tab
        courseNavigationController = modules.course
		communityNavigationController = modules.community
    }

    func decideWhatModuleToShowFirst() {
        if tokenManager.get() != nil {
            moduleWantsToOpenAuthorized()
        } else {
            moduleWantsToOpenAuth()
        }
    }

    func moduleWantsToOpenTasks(with id: Int) {
        let tasksVc = assembly.createTasksScreen(router: self, id: id, container: container)
        courseNavigationController?.pushViewController(tasksVc, animated: true)
    }
	
	func moduleWantsToOpenLeaderboard() {
		let leaderboardVC = assembly.createLeaderboardScreen(router: self, container: container)
		communityNavigationController?.pushViewController(leaderboardVC, animated: true)
	}
	
	func moduleWantsToOpenBattleScreen() {
		let battleVC = assembly.createBattleScreen(router: self, container: container)
		communityNavigationController?.pushViewController(battleVC, animated: true)
	}
}
