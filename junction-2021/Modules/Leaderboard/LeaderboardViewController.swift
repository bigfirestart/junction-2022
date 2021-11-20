//
//  LeaderboardViewController.swift
//  junction-2021
//
//  Created by k.lukyanov on 20.11.2021.
//

import UIKit

class LeaderboardViewController: UIViewController {
	var presenter: LeaderboardPresenterProtocol?
	
	private enum Constants {
		static let tableCell = String(describing: LeaderBoardWithActionCell.self)
		static let spaceReuseId = String(describing: SpaceCell.self)
	}
	
	private lazy var tableView: UITableView = {
		let table = UITableView()
		table.delegate = self
		table.dataSource = self
		table.register(SpaceCell.self, forCellReuseIdentifier: Constants.spaceReuseId)
		
		table.register(UINib(resource: R.nib.leaderBoardWithActionCell), forCellReuseIdentifier: Constants.tableCell)
		return table
	}()
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		title = "Leaderboard"
		
		DispatchQueue.main.async { [weak self] in
			self?.navigationController?.navigationBar.sizeToFit()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .appBackground()
		
		setupTable()
	}
	
	private func setupTable() {
		view.addSubview(tableView)
		tableView.backgroundColor = .appBackground()
		tableView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}

		tableView.separatorStyle = .none
		tableView.contentInset = UIEdgeInsets(top: 45, left: 0, bottom: 0, right: 0)
	}
}

extension LeaderboardViewController: UITableViewDelegate {
	
}

extension LeaderboardViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		20
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return tableView.dequeueReusableCell(withIdentifier: Constants.tableCell, for: indexPath)
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		1
	}
}
