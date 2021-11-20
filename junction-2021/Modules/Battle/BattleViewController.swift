//
//  BattleViewController.swift
//  junction-2021
//
//  Created by k.lukyanov on 20.11.2021.
//

import UIKit
import StepIndicator

class BattleViewController: UIViewController {
	var presenter: BattlePresenterProtocol?
	
	@IBOutlet weak var rullesBanner: UIView!
	@IBOutlet weak var rullesBannerLabel: UILabel!
	
	@IBOutlet weak var userProgress: StepIndicatorView!
	@IBOutlet weak var enemyProgress: StepIndicatorView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		rullesBanner.layer.cornerRadius = 14
		
		enemyProgress.numberOfSteps = 7
		enemyProgress.currentStep  = 3
		
		userProgress.numberOfSteps = 7
		userProgress.currentStep = 5
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		title = "Battle"
		
		DispatchQueue.main.async { [weak self] in
			self?.navigationController?.navigationBar.sizeToFit()
		}
	}

}
