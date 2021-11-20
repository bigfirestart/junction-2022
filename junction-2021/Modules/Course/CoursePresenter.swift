//
//  CoursePresenter.swift
//  junction-2021
//
//  Created by b.belotserkovtsev on 19.11.2021.
//

import Foundation

protocol CoursePresenterProtocol: AnyObject {
    func viewDidLoadEvent()
    func didTapStage(with: StagesResponse)
}

final class CoursePresenter: CoursePresenterProtocol {

    private weak var view: CourseViewControllerProtocol?
    private let networkService: NetworkServiceProtocol
    private let router: RouterProtocol
	
    init(router: RouterProtocol, view: CourseViewControllerProtocol, networkService: NetworkServiceProtocol) {
        self.router = router
        self.view = view
        self.networkService = networkService
    }

    func viewDidLoadEvent() {
        networkService.stages { [weak self] result in
            switch result {
            case .success(let data):
                self?.view?.setStageState(with: .data(data))
            case .failure:
                self?.view?.setStageState(with: .loading)
            }
        }

        networkService.team { [weak self] result in
            switch result {
            case .success(let data):
                self?.view?.setTeamState(with: .data(data))
            case .failure:
                self?.view?.setTeamState(with: .loading)
            }
        }
    }

    func didTapStage(with data: StagesResponse) {
        router.moduleWantsToOpenTasks(with: data.id)
    }
}
