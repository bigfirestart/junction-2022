//
//  TaskPresenter.swift
//  junction-2021
//
//  Created by b.belotserkovtsev on 20.11.2021.
//

import Foundation

protocol TasksPresenterProtocol: AnyObject {
    func viewDidloadEvent()
    func refresh()
    func didPressSubmit(isCheckpoint: Bool, id: Int, values: [String: String])
}

class TasksPresenter {
    weak var view: TasksViewControllerProtocol?
    private let id: Int
    private let networkService: NetworkServiceProtocol

    init(view: TasksViewControllerProtocol, networkService: NetworkServiceProtocol, id: Int) {
        self.view = view
        self.networkService = networkService
        self.id = id
    }
}

extension TasksPresenter: TasksPresenterProtocol {
    func didPressSubmit(isCheckpoint: Bool, id: Int, values: [String : String]) {
        networkService.submit(id: id, isCheckpoint: isCheckpoint, values: values) { [weak self] in
            self?.refresh()
        }
    }

    func viewDidloadEvent() {
        refresh()
    }

    func refresh() {
        networkService.team { [weak self] result in
            switch result {
            case .success(let team):
                self?.view?.setTeamState(with: .data(team))
            case .failure:
                self?.view?.setTeamState(with: .loading)
            }
        }

        networkService.tasks(stageId: id) { [weak self] result in
            switch result {
            case .success(let tasks):
                self?.view?.setTasksState(with: .data(tasks))
            case .failure:
                self?.view?.setTasksState(with: .loading)
            }
        }
    }
}
