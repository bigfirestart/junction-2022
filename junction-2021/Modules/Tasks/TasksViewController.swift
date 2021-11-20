//
//  TaskViewController.swift
//  junction-2021
//
//  Created by b.belotserkovtsev on 20.11.2021.
//

import UIKit

protocol TasksViewControllerProtocol: AnyObject {

}

class TasksViewController: UIViewController {
    var presenter: TasksPresenterProtocol?

    private enum Constants {
        static let teamReuseId = String(describing: TeamTableViewCell.self)
        static let headerReuseId = String(describing: TitleWithRoundTopHeader.self)
        static let footerReuseId = String(describing: RoundFooter.self)
        static let taskReuseId = String(describing: TaskTableViewCell.self)
        static let spacingReuseId = String(describing: SpacingWithRoundTopBottomCell.self)
        static let tableViewContentInset = UIEdgeInsets(top: 45, left: 0, bottom: 16, right: 0)
    }
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.delegate = self
        table.dataSource = self

        table.register(UINib(resource: R.nib.teamTableViewCell), forCellReuseIdentifier: Constants.teamReuseId)
        table.register(UINib(resource: R.nib.taskTableViewCell), forCellReuseIdentifier: Constants.taskReuseId)
        table.register(SpacingWithRoundTopBottomCell.self, forCellReuseIdentifier: Constants.spacingReuseId)

        table.register(TitleWithRoundTopHeader.self, forHeaderFooterViewReuseIdentifier: Constants.headerReuseId)
        table.register(TitleWithRoundTopHeader.self, forHeaderFooterViewReuseIdentifier: Constants.footerReuseId)

        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.navigationBar.sizeToFit()
        }
    }

    private func setupView() {
        view.addSubview(tableView)

        title = "Tasks"
        view.backgroundColor = .appBackground()

//        hideKeyboardOnTap()

        setupTable()
    }

    private func setupTable() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tableView.separatorStyle = .none
        tableView.backgroundColor = .appBackground()
        tableView.contentInset = Constants.tableViewContentInset
    }
}

extension TasksViewController: TasksViewControllerProtocol {
    
}

extension TasksViewController: UITableViewDelegate {

}

extension TasksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 3
        }
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.teamReuseId, for: indexPath)
            return cell
        } else if section == 1 {
            if row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.taskReuseId, for: indexPath)
                return cell
            } else if row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.spacingReuseId, for: indexPath)
                return cell
            } else if row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.taskReuseId, for: indexPath)
                return cell
            }
            return UITableViewCell()
        } else if section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.taskReuseId, for: indexPath)
            return cell
        } else {
            return UITableViewCell()
        }

    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.headerReuseId) as? TitleWithRoundTopHeader
            header?.configure(with: .init(titleColor: .orange, text: "Checkpoint"))
            return header
        } else if section == 2 {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.headerReuseId) as? TitleWithRoundTopHeader
            header?.configure(with: .init(titleColor: .black, text: "Unresolved tasks"))
            return header
        }

        let view = UIView()
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return UITableView.automaticDimension
        } else if section == 2 {
            return UITableView.automaticDimension
        }

        return .leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return UITableView.automaticDimension
        } else if section == 2 {
            return UITableView.automaticDimension
        }
        return .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            return RoundFooter()
        } else if section == 2 {
            return RoundFooter()
        }
        let view = UIView()
        return view
    }
}
