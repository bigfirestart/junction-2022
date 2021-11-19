//
//  TokenManager.swift
//  junction-2021
//
//  Created by b.belotserkovtsev on 19.11.2021.
//

import Foundation

protocol TokenManagerProtocol {
    func set(token: String)
    func get() -> String?
}

final class TokenManager: TokenManagerProtocol {
    private let keyChain = KeyChainService()
    private var cashedToken: String?
    private var token: String? {
        get {
            if cashedToken != nil {
                return cashedToken
            }
            if let token = keyChain.getFromKeyChain() {
                cashedToken = token
                return token
            }
            return nil
        }
        set(token) {
            if let newToken = token {
                let savedInKeyChain = keyChain.setToKeyChain(token: newToken)
                if savedInKeyChain {
                    cashedToken = token
                }
            }

        }
    }

    func set(token: String) {
        self.token = token
    }

    func get() -> String? {
        token
    }
}
