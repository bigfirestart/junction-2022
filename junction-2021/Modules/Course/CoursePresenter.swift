//
//  CoursePresenter.swift
//  junction-2021
//
//  Created by b.belotserkovtsev on 19.11.2021.
//

import Foundation

protocol CoursePresenterProtocol: AnyObject {
    func viewDidLoadEvent()
}

final class CoursePresenter: CoursePresenterProtocol {

    private weak var view: CourseViewControllerProtocol?
    private let router: RouterProtocol
	
    init(router: RouterProtocol, view: CourseViewControllerProtocol) {
        self.router = router
        self.view = view
    }

    func viewDidLoadEvent() {
        
    }
}
