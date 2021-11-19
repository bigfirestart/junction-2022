//
//  KeyChainService.swift
//  junction-2021
//
//  Created by k.lukyanov on 19.11.2021.
//
import UIKit

final class KeyChainService {
	private let account = "junction"
	private let server = "teamnull.com"
	
	func setToKeyChain(token: String) -> Bool {
		let keychainItem = [
		  kSecValueData: token.data(using: .utf8)!,
		  kSecAttrAccount: account,
		  kSecAttrServer: server,
		  kSecClass: kSecClassInternetPassword,
		  kSecReturnData: true
		] as CFDictionary

		let status = SecItemAdd(keychainItem, nil)
		return status == 0
	}
	
	func getFromKeyChain() -> String? {
		let query = [
		  kSecClass: kSecClassInternetPassword,
		  kSecAttrServer: server,
		  kSecReturnAttributes: true,
		  kSecReturnData: true
		] as CFDictionary

		var result: AnyObject?
		SecItemCopyMatching(query, &result)
		
		if let dict = result as? NSDictionary,
		   let token = dict[kSecValueData] as? Data {
			return (String(data: token, encoding: .utf8))
		}
		return nil
	}
	
	func deleteFromKeyChain() {
		let query = [
		  kSecClass: kSecClassInternetPassword,
		  kSecAttrServer: server,
		  kSecReturnAttributes: true,
		  kSecReturnData: true
		] as CFDictionary

		SecItemDelete(query)
	}
}
