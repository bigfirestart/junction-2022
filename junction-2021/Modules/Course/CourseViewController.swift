//
//  CourseViewController.swift
//  junction-2021
//
//  Created by b.belotserkovtsev on 19.11.2021.
//

import UIKit

protocol CourseViewControllerProtocol: AnyObject {
    func setStageState(with: CourseViewController.StageState)
    func setTeamState(with: CourseViewController.TeamState)
}

final class CourseViewController: UIViewController {

    var presenter: CoursePresenterProtocol?
    var stageState: StageState = .loading {
        didSet {
            tableView.reloadData()
        }
    }
    var teamState: TeamState = .loading {
        didSet {
            tableView.reloadData()
        }
    }

    private enum Constants {
        static let teamReuseId = String(describing: TeamTableViewCell.self)
        static let stageReuseId = String(describing: StageTableViewCell.self)
        static let headerReuseId = String(describing: TitleWithRoundTopHeader.self)
        static let footerReuseId = String(describing: RoundFooter.self)
        static let loaderReuseId = String(describing: LoadingCell.self)
        static let tableViewContentInset = UIEdgeInsets(top: 45, left: 0, bottom: 16, right: 0)
    }

    enum StageState {
        case loading
        case data([StagesResponse])
    }

    enum TeamState {
        case loading
        case data(TeamResponse)
    }

    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.register(UINib(resource: R.nib.teamTableViewCell), forCellReuseIdentifier: Constants.teamReuseId)
        table.register(UINib(resource: R.nib.stageTableViewCell), forCellReuseIdentifier: Constants.stageReuseId)
        table.register(LoadingCell.self, forCellReuseIdentifier: Constants.loaderReuseId)

        table.register(TitleWithRoundTopHeader.self, forHeaderFooterViewReuseIdentifier: Constants.headerReuseId)
        table.register(TitleWithRoundTopHeader.self, forHeaderFooterViewReuseIdentifier: Constants.footerReuseId)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        presenter?.viewDidLoadEvent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        title = "Course"

        // даже не пытайся в это вникнуть. вахвахавх
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.navigationBar.sizeToFit()
        }
    }

    private func setupView() {
        view.backgroundColor = .appBackground()

        setupTable()
    }

    private func setupTable() {
        view.addSubview(tableView)
        tableView.backgroundColor = .appBackground()
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tableView.separatorStyle = .none
        tableView.contentInset = Constants.tableViewContentInset
    }
}

extension CourseViewController: CourseViewControllerProtocol {
    func setStageState(with state: StageState) {
        self.stageState = state
    }

    func setTeamState(with state: TeamState) {
        self.teamState = state
    }
}

extension CourseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didTapStage()
    }
}

extension CourseViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }

        switch stageState {
        case .data(let stages):
            return stages.count
        case .loading:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section

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
        }

        switch stageState {
        case .data(let stages):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.stageReuseId, for: indexPath) as? StageTableViewCell else {
                print("🟥 Could not dequeue cell: \(Constants.stageReuseId)")
                return UITableViewCell()
            }

            cell.configure(with: .init(stageName: stages[indexPath.row].name,
                                        stageNumber: String(stages[indexPath.row].id),
                                        statusImage: nil,
                                        battleImage: indexPath.row == 0 ?  R.image.swordsIcon() : nil))
            return cell
        case .loading:
            return tableView.dequeueReusableCell(withIdentifier: Constants.loaderReuseId, for: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.headerReuseId)
            return header
        }

        let view = UIView()
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return UITableView.automaticDimension
        }

        return .leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return UITableView.automaticDimension
        }
        return .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            return RoundFooter()
        }
        let view = UIView()
        return view
    }
}
