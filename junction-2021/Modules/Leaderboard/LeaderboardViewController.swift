//
//  LeaderboardViewController.swift
//  junction-2021
//
//  Created by k.lukyanov on 20.11.2021.
//

import UIKit

protocol LeaderboardViewControllerProtocol: AnyObject {
	func setState(with: LeaderboardViewController.State)
}

class LeaderboardViewController: UIViewController {
	var presenter: LeaderboardPresenterProtocol?
	
	private enum Constants {
		static let tableCell = String(describing: LeaderBoardCell.self)
		static let spaceReuseId = String(describing: SpaceCell.self)
		static let loaderReuseId = String(describing: LoadingCell.self)
	}
	
	enum State {
		case loading
		case data([LeaderboardResponse])
	}
	
	var state: State = .loading {
		didSet {
			tableView.reloadData()
		}
	}
	
	private lazy var tableView: UITableView = {
		let table = UITableView()
		table.delegate = self
		table.dataSource = self
		table.register(SpaceCell.self, forCellReuseIdentifier: Constants.spaceReuseId)
		
		table.register(UINib(resource: R.nib.leaderBoardCell), forCellReuseIdentifier: Constants.tableCell)
		table.register(LoadingCell.self, forCellReuseIdentifier: Constants.loaderReuseId)
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
		presenter?.viewDidLoadEvent()
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
		switch state {
		case .data(let stages):
			return stages.count
		case .loading:
			return 1
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch state {
		case .data(let leaderboard):
			guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tableCell, for: indexPath) as? LeaderBoardCell else {
				print("🟥 Could not dequeue cell: \(Constants.tableCell)")
				return UITableViewCell()
			}

			cell.configure(model: leaderboard[indexPath.row])
			return cell
		case .loading:
			return tableView.dequeueReusableCell(withIdentifier: Constants.loaderReuseId, for: indexPath)
		}
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		1
	}
}

extension LeaderboardViewController: LeaderboardViewControllerProtocol {
	func setState(with state: State) {
		self.state = state
	}
}
