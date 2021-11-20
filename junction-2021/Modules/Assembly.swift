//
//  BuilderAssebly.swift
//  junction-2021
//
//  Created by k.lukyanov on 19.11.2021.
//

import UIKit
import Swinject

protocol AssemblyProtocol: AnyObject {
    func createAuthScreen(router: RouterProtocol, container: Container) -> UIViewController
    func createAuthorizedScreens(router: RouterProtocol, container: Container) -> (tab: UITabBarController, course: UINavigationController, community: UINavigationController)
    func createTasksScreen(router: RouterProtocol, id: Int, container: Container) -> UIViewController
	func createLeaderboardScreen(router: RouterProtocol, container: Container) -> UIViewController
	func createBattleScreen(router: RouterProtocol, container: Container) -> UIViewController
}

final class Assembly: AssemblyProtocol {
    func createAuthScreen(router: RouterProtocol, container: Container) -> UIViewController {
		let view = AuthViewController()
        let presenter = AuthPresenter(view: view, router: router, network: container.resolve(), tokenManager: container.resolve())
		view.presenter = presenter
		return view
	}

	func createAuthorizedScreens(router: RouterProtocol, container: Container) -> (tab: UITabBarController, course: UINavigationController, community: UINavigationController) {
		
		// Course
        let courseView = CourseViewController()
        let coursePresenter = CoursePresenter(router: router, view: courseView, networkService: container.resolve())
		courseView.presenter = coursePresenter
		
        let courseNavigationController = UINavigationController()
		courseNavigationController.makeAppCustomNavigationBar()
        courseNavigationController.navigationBar.prefersLargeTitles = true
        courseNavigationController.pushViewController(courseView, animated: false)
        let courseItem = UITabBarItem(title: "Course", image: R.image.tabBarCourses(), selectedImage: R.image.tabBarCourses())
        courseNavigationController.tabBarItem = courseItem
		
		// Community
		let communityView = CommunityViewController()
		let communityPresenter = CommunityPresenter(router: router, view: courseView)
		communityView.presenter = communityPresenter
		
		let communityNavigationController = UINavigationController()
		communityNavigationController.makeAppCustomNavigationBar()
		communityNavigationController.navigationBar.prefersLargeTitles = true
		communityNavigationController.pushViewController(communityView, animated: false)
		let communityItem = UITabBarItem(title: "Community", image: R.image.tabBarCommunity(), selectedImage: R.image.tabBarCommunity())
		communityNavigationController.tabBarItem = communityItem
		
        let tabController = UITabBarController()
		tabController.viewControllers = [courseNavigationController, communityNavigationController]

		return (tab: tabController,
				course: courseNavigationController,
				community: communityNavigationController)
    }

    func createTasksScreen(router: RouterProtocol, id: Int, container: Container) -> UIViewController {
        let tasksViewController = TasksViewController()
        let tasksPresenter = TasksPresenter(view: tasksViewController, networkService: container.resolve(), id: id)
        tasksViewController.presenter = tasksPresenter

        return tasksViewController
    }
	
	func createLeaderboardScreen(router: RouterProtocol, container: Container) -> UIViewController {
		let leaderboardViewController = LeaderboardViewController()
		let leaderboardPresenter = LeaderboardPresenter(router: router, view: leaderboardViewController)
		leaderboardViewController.presenter = leaderboardPresenter

		return leaderboardViewController
	}
	
	func createBattleScreen(router: RouterProtocol, container: Container) -> UIViewController {
		let vc = BattleViewController()
		let battlePresenter = BattlePresenter(router: router, view: vc)
		vc.presenter = battlePresenter
		
		return vc
	}
}
