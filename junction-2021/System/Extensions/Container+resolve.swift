//
//  Container.swift
//  junction-2021
//
//  Created by b.belotserkovtsev on 19.11.2021.
//

import Swinject

extension Container {
    func resolve<Service>() -> Service {
        resolve(Service.self)!
    }
}
