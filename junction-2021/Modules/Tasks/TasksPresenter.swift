//
//  TaskPresenter.swift
//  junction-2021
//
//  Created by b.belotserkovtsev on 20.11.2021.
//

import Foundation

protocol TasksPresenterProtocol: AnyObject {

}

class TasksPresenter {
    weak var view: TasksViewControllerProtocol?

    init(view: TasksViewControllerProtocol) {
        self.view = view
    }
}

extension TasksPresenter: TasksPresenterProtocol {

}
