//
//  TaskViewController.swift
//  junction-2021
//
//  Created by b.belotserkovtsev on 20.11.2021.
//

import UIKit

protocol TasksViewControllerProtocol: AnyObject {
    func setTeamState(with: TasksViewController.TeamState)
    func setTasksState(with: TasksViewController.TasksState)
}

class TasksViewController: UIViewController {
    var presenter: TasksPresenterProtocol?

    private enum Constants {
        static let teamReuseId = String(describing: TeamTableViewCell.self)
        static let headerReuseId = String(describing: TitleWithRoundTopHeader.self)
        static let footerReuseId = String(describing: RoundFooter.self)
        static let taskReuseId = String(describing: TaskTableViewCell.self)
        static let spacingReuseId = String(describing: SpacingWithRoundTopBottomCell.self)
        static let loadingReuseId = String(describing: LoadingCell.self)
        static let tableViewContentInset = UIEdgeInsets(top: 45, left: 0, bottom: 16, right: 0)
    }

    var teamState: TeamState = .loading {
        didSet {
            tableView.reloadSections(.init(integer: 0), with: .fade)
        }
    }

    var tasksState: TasksState = .loading {
        didSet {
            tableView.reloadSections(.init(1...2), with: .fade)
        }
    }

    enum TeamState {
        case loading
        case data(TeamResponse)
    }

    enum TasksState {
        case loading
        case data(TasksResponse)
    }
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.delegate = self
        table.dataSource = self

        table.register(UINib(resource: R.nib.teamTableViewCell), forCellReuseIdentifier: Constants.teamReuseId)
        table.register(UINib(resource: R.nib.taskTableViewCell), forCellReuseIdentifier: Constants.taskReuseId)
        table.register(SpacingWithRoundTopBottomCell.self, forCellReuseIdentifier: Constants.spacingReuseId)
        table.register(LoadingCell.self, forCellReuseIdentifier: Constants.loadingReuseId)

        table.register(TitleWithRoundTopHeader.self, forHeaderFooterViewReuseIdentifier: Constants.headerReuseId)
        table.register(TitleWithRoundTopHeader.self, forHeaderFooterViewReuseIdentifier: Constants.footerReuseId)

        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        setupView()
        presenter?.viewDidloadEvent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.navigationBar.sizeToFit()
        }
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if additionalSafeAreaInsets.bottom == 0 {
                UIView.animate(withDuration: 1) {
                    self.additionalSafeAreaInsets.bottom += keyboardSize.height
                    self.view.layoutIfNeeded()
                }

            }

        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        if additionalSafeAreaInsets.bottom != 0 {
            UIView.animate(withDuration: 1) {
                self.additionalSafeAreaInsets.bottom = 0
                self.view.layoutIfNeeded()
            }
        }
    }

    private func setupView() {
        view.addSubview(tableView)

        title = "Tasks"
        view.backgroundColor = .appBackground()

        hideKeyboardOnTap()

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
    func setTasksState(with state: TasksState) {
        tasksState = state
    }

    func setTeamState(with state: TeamState) {
        teamState = state
    }
}

extension TasksViewController: UITableViewDelegate {

}

extension TasksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        }

        switch tasksState {
        case .data(let model):
            return model.tasks.count + model.tasks.count - 1
        case .loading:
            return 1
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            switch teamState {
            case .data(let team):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.teamReuseId, for: indexPath) as? TeamTableViewCell else {
                    print("🟥 Could not dequeue cell: \(Constants.teamReuseId)")
                    return UITableViewCell()
                }
                cell.configure(with: .data(.init(teamName: team.name, points: Float(team.points) / 10)))
                return cell
            case .loading:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.teamReuseId, for: indexPath) as? TeamTableViewCell else {
                    print("🟥 Could not dequeue cell: \(Constants.teamReuseId)")
                    return UITableViewCell()
                }
                cell.configure(with: .loading)
                return cell
            }
        } else if section == 1 {
            switch tasksState {
            case .data(let model):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.taskReuseId) as? TaskTableViewCell else {
                    print("🟥 Could not dequeue cell: \(Constants.taskReuseId)")
                    return UITableViewCell()
                }

                cell.configure(with: model.checkpoint)
                return cell
            case .loading:
                return tableView.dequeueReusableCell(withIdentifier: Constants.loadingReuseId, for: indexPath)
            }
        }

        switch tasksState {
        case .data(let model):
            if row % 2 != 0 {
                return tableView.dequeueReusableCell(withIdentifier: Constants.spacingReuseId, for: indexPath)
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.taskReuseId) as? TaskTableViewCell else {
                print("🟥 Could not dequeue cell: \(Constants.taskReuseId)")
                return UITableViewCell()
            }

            cell.configure(with: model.tasks[row / 2])
            return cell
        case .loading:
            return tableView.dequeueReusableCell(withIdentifier: Constants.loadingReuseId, for: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.headerReuseId) as? TitleWithRoundTopHeader
            header?.configure(with: .init(titleColor: .orange, text: "Checkpoint"))
            return header
        } else if section == 2 {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.headerReuseId) as? TitleWithRoundTopHeader
            header?.configure(with: .init(titleColor: .black, text: "Tasks"))
            return header
        }

        let view = UIView()
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? .leastNonzeroMagnitude : UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? .leastNormalMagnitude : UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return section == 0 ? UIView() : RoundFooter()
    }
}
