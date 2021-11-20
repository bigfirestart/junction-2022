//
//  BattleViewController.swift
//  junction-2021
//
//  Created by k.lukyanov on 20.11.2021.
//

import UIKit

class BattleViewController: UIViewController {
	var presenter: BattlePresenterProtocol?
	
	@IBOutlet weak var rullesBanner: UIView!
	@IBOutlet weak var rullesBannerLabel: UILabel!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		rullesBanner.layer.cornerRadius = 14
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		title = "Battle"
		
		DispatchQueue.main.async { [weak self] in
			self?.navigationController?.navigationBar.sizeToFit()
		}
	}

}
