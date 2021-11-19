//
//  InitialSetupService.swift
//  junction-2021
//
//  Created by b.belotserkovtsev on 19.11.2021.
//

import Swinject

protocol InitialSetupServiceProtocol {
    func buildAndPresentInitialRouter(in window: UIWindow?)
}

final class InitialSetupService: InitialSetupServiceProtocol {
    private func buildDependencyContainer() -> Container {
        let container = Container()

        container.register(NetworkServiceProtocol.self) { _ in
            NetworkService()
        }.inObjectScope(.container)

        container.register(AssemblyProtocol.self) { _ in
            Assembly()
        }.inObjectScope(.container)

        container.register(TokenManagerProtocol.self) { _ in
            TokenManager()
        }.inObjectScope(.container)

        return container
    }

    func buildAndPresentInitialRouter(in window: UIWindow?) {
        let container = buildDependencyContainer()
        let router = Router(container: container, window: window)
        router.decideWhatModuleToShowFirst()
        window?.makeKeyAndVisible()
    }
}
