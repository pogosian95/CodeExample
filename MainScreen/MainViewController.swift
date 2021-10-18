//
//  MainViewController.swift
//  AffirmationDays
//
//  Created by Oleg Pogosian on 14.10.2021.
//

import UIKit

protocol MainViewControllerProtocol: BaseViewControllerProtocol {

}

class MainViewController: UIViewController {
        
    // MARK: - IBOutlets
    @IBOutlet weak var hiUserLabel: UILabel!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var presenter: MainPresenterProtocol!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MainPresenter(view: self)
        
        setupViews()
    }
    
    // MARK: - UI
    private func setupViews() {
        setupTableView()
        setupButtons()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CurrentAffirmationsTableViewCell.self)
        tableView.register(LockedAffirmationsTableViewCell.self)
    }
    
    private func setupButtons() {
        buttonsView.viewCorner(buttonsView.frame.height / 2)
        textButton.viewCorner(textButton.frame.height / 2)
        audioButton.viewCorner(audioButton.frame.height / 2)
        textButton.backgroundColor = .appColor(.selectedAppColor)
        textButton.setTitleColor(.white, for: .normal)
        audioButton.setTitleColor(.black, for: .normal)
    }
    
    // MARK: - IBActions
    @IBAction func textButtonAction(_ sender: Any) {
        textButton.backgroundColor = .appColor(.selectedAppColor)
        textButton.setTitleColor(.white, for: .normal)
        audioButton.setTitleColor(.black, for: .normal)
        audioButton.backgroundColor = .clear
    }
    
    @IBAction func audioButtonAction(_ sender: Any) {
        audioButton.backgroundColor = .appColor(.selectedAppColor)
        audioButton.setTitleColor(.white, for: .normal)
        textButton.setTitleColor(.black, for: .normal)
        textButton.backgroundColor = .clear
    }
    
}

extension MainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.getSectionsCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getCellsCountFor(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = presenter.getCellTypeFor(section: indexPath.section)
        switch type {
        case .openedAffirm:
            let cell = tableView.create(CurrentAffirmationsTableViewCell.self, indexPath)
            presenter.configurateCell(cell, item: indexPath.row)
            return cell
        case .closedAffirm:
            let cell = tableView.create(LockedAffirmationsTableViewCell.self, indexPath)
            presenter.configurateCell(cell, item: indexPath.row)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "My journeys"
        } else {
            return "All journeys"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
}

extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = presenter.getCellTypeFor(section: indexPath.section)
        presenter.cellPressed(type: type, row: indexPath.row)
    }
    
}

extension MainViewController: MainViewControllerProtocol {

}
