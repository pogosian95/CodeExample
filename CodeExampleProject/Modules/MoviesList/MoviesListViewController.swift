//
//  MoviesListViewController.swift
//  CodeExampleProject
//
//  Created by Oleg Pogosian on 21.10.2021.
//

import UIKit

protocol MoviesListViewControllerProtocol: BaseViewControllerProtocol {
    func reloadTable()
    func stopRefreshing()
}

class MoviesListViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var presenter: MoviesListPresenterProtocol!
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MoviesListPresenter(view: self)
        
        setupViews()
    }
    
    // MARK: - UI
    private func setupViews() {
        self.title = "Top Movies"
        setupTableView()
        setupTableViewRefresh()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieInfoTableViewCell.self)
    }
    
    private func setupTableViewRefresh() {
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        
        tableView.refreshControl = refreshControl
    }
    
    // MARK: - Actions
    @objc private func pullToRefresh() {
        presenter.tableViewPulled()
    }
    
}

extension MoviesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getCellCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.create(MovieInfoTableViewCell.self, indexPath)
        presenter.configurateCell(cell, item: indexPath.row)
        return cell
    }
    
}

extension MoviesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter.willDisplayCell(item: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.cellPressed(item: indexPath.row)
    }
    
}

extension MoviesListViewController: MoviesListViewControllerProtocol {
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func stopRefreshing() {
        DispatchQueue.main.async {
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
}
