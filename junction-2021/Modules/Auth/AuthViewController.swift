//
//  AuthViewController.swift
//  junction-2021
//
//  Created by k.lukyanov on 19.11.2021.
//

import UIKit
import SnapKit
import Foundation

final class AuthViewController: UIViewController {
	var presenter: AuthPresenterProtocol?
	
	lazy var mount = BackgroundMount()
	lazy var nameInput = TextField()
	lazy var passwordInput = TextField()
	lazy var submitButton = Button()
	lazy var appTitle = UILabel()
	lazy var errorField = UILabel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupSubViews()
		submitButton.addTarget(self, action: #selector(submitPressed), for: .touchUpInside)
	}
	
	@objc private func submitPressed() {
		if let username = nameInput.text,
		   let password = passwordInput.text {
			presenter?.login(username: username, password: password)
		}
	}
	
	private func setupSubViews() {
		view.backgroundColor = .appBackground()
		
		// Mount
		view.addSubview(mount)
		mount.snp.makeConstraints { (make) -> Void in
			make.width.equalTo(self.view).multipliedBy(0.8)
			make.height.equalTo(self.view).multipliedBy(0.5)
			make.center.equalTo(self.view)
		}
		
		// Username
		mount.addSubview(nameInput)
		nameInput.text = "Username"
		nameInput.snp.makeConstraints { (make) -> Void in
			make.width.equalTo(mount).multipliedBy(0.8)
			make.height.equalTo(50)
			make.centerX.equalTo(mount)
			make.centerY.equalTo(mount).offset(-30)
		}
		
		// Password
		
		mount.addSubview(passwordInput)
		passwordInput.text = "Password"
		passwordInput.snp.makeConstraints { (make) -> Void in
			make.width.equalTo(mount).multipliedBy(0.8)
			make.height.equalTo(50)
			make.centerX.equalTo(mount)
			make.centerY.equalTo(mount).offset(30)
		}
		
		// Error Field
		mount.addSubview(errorField)
		errorField.textColor = .red
		errorField.textAlignment = .center
		errorField.snp.makeConstraints { (make) -> Void in
			make.width.equalTo(mount).multipliedBy(0.8)
			make.height.equalTo(50)
			make.centerX.equalTo(mount)
			make.centerY.equalTo(nameInput).offset(-50)
		}
		
		// Title
		mount.addSubview(appTitle)
		appTitle.text = "Junction 2021"
		appTitle.font = .boldSystemFont(ofSize: 34)
		appTitle.textAlignment = .center
		appTitle.snp.makeConstraints { (make) -> Void in
			make.width.equalTo(mount).multipliedBy(0.8)
			make.height.equalTo(50)
			make.centerX.equalTo(mount)
			make.centerY.equalTo(errorField).offset(-45)
		}
		
		// Button
		mount.addSubview(submitButton)
		submitButton.setTitle("Login", for: .normal)
		submitButton.snp.makeConstraints { (make) -> Void in
			make.width.equalTo(mount).multipliedBy(0.8)
			make.height.equalTo(50)
			make.centerX.equalTo(mount)
			make.centerY.equalTo(passwordInput).offset(70)
		}
	}
	
	func invalidLogin(message: String) {
		self.errorField.text = message
		errorField.sizeToFit()
		self.passwordInput.text = ""
	}

}
