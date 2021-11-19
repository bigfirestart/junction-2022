//
//  CommunityViewController.swift
//  junction-2021
//
//  Created by k.lukyanov on 19.11.2021.
//

import UIKit

final class CommunityViewController: UIViewController {
	var presenter: CommunityPresenterProtocol?

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .appBackground()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		title = "Community"

		//даже не пытайся в это вникнуть. вахвахавх
		DispatchQueue.main.async { [weak self] in
			self?.navigationController?.navigationBar.sizeToFit()
		}
	}
	
	

}
