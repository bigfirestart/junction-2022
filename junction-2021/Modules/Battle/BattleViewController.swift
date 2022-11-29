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
	
    @IBOutlet weak var opponetLabel: UILabel!
    @IBOutlet weak var yourTeamLabel: UILabel!
    @IBOutlet weak var userProgress: StepIndicatorView!
	@IBOutlet weak var enemyProgress: StepIndicatorView!
    
    var progress: BattleProgress?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		rullesBanner.layer.cornerRadius = 14
        
        guard let progress = progress else {
            return
        }

        enemyProgress.numberOfSteps = progress.defenderProgress.count

        enemyProgress.currentStep = progress.defenderProgress.compactMap {
            $0.done == true ? $0 : nil
        }.count
        
        userProgress.numberOfSteps = progress.initiatorProgress.count
        userProgress.currentStep = progress.initiatorProgress.compactMap {
            $0.done == true ? $0 : nil
        }.count
        
        yourTeamLabel.text = progress.battle.initiator.name
        opponetLabel.text = progress.battle.defender.name
       
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		title = "Battle"
		
		DispatchQueue.main.async { [weak self] in
			self?.navigationController?.navigationBar.sizeToFit()
		}
	}
}
