//
//  AppDelegate.swift
//  junction-2021
//
//  Created by b.belotserkovtsev on 19.11.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let initialSetupService: InitialSetupServiceProtocol = InitialSetupService()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow()

        initialSetupService.buildAndPresentInitialRouter(in: window)
		
        return true
    }

}
