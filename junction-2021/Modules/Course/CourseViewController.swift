//
//  CourseViewController.swift
//  junction-2021
//
//  Created by b.belotserkovtsev on 19.11.2021.
//

import UIKit

protocol CourseViewControllerProtocol: AnyObject {

}

final class CourseViewController: UIViewController {

    var presenter: CoursePresenterProtocol?
    var state: State = .loading {
        didSet {
            handleState()
        }
    }

    private enum Constants {
        static let teamReuseId = String(describing: TeamTableViewCell.self)
        static let stageReuseId = String(describing: StageTableViewCell.self)
        static let headerReuseId = String(describing: TitleWithRoundTopHeader.self)
        static let footerReuseId = String(describing: RoundFooter.self)
        static let tableViewContentInset = UIEdgeInsets(top: 45, left: 0, bottom: 16, right: 0)
    }

    enum State {
        struct Model {

        }
        case loading
        case data(Model)
    }

    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.register(UINib(resource: R.nib.teamTableViewCell), forCellReuseIdentifier: Constants.teamReuseId)
        table.register(UINib(resource: R.nib.stageTableViewCell), forCellReuseIdentifier: Constants.stageReuseId)

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

    private func handleState() {
        switch state {
        case .data:
            break
        case .loading:
            break
        }
    }
}

extension CourseViewController: CourseViewControllerProtocol {

}

extension CourseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? TeamTableViewCell
        cell?.animateTap()
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? TeamTableViewCell
        cell?.animateRelease()
    }
}

extension CourseViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 10
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        let section = indexPath.section

        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.teamReuseId, for: indexPath)
            return cell
        } else if section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.stageReuseId, for: indexPath) as? StageTableViewCell
            cell?.configure(with: .init(stageName: "Test stage", stageNumber: "1.", image: nil))
            return cell!
        } else {
            return UITableViewCell()
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
