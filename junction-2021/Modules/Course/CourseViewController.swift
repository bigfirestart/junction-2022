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
        static let reuseId = String(describing: TeamTableViewCell.self)
    }

    enum State {
        struct Model {
            
        }
        case loading
        case data(Model)
    }

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(UINib(resource: R.nib.teamTableViewCell), forCellReuseIdentifier: Constants.reuseId)
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

        //даже не пытайся в это вникнуть. вахвахавх
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
        tableView.contentInset = UIEdgeInsets(top: 45, left: 0, bottom: 0, right: 0)
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseId, for: indexPath)

        return cell
    }
}
