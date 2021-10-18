//
//  MainPresenter.swift
//  AffirmationDays
//
//  Created by Oleg Pogosian on 14.10.2021.
//

import Foundation

protocol MainPresenterProtocol {
    init(view: MainViewControllerProtocol)
    func getCellTypeFor(section: Int) -> MainPresenter.CellType
    func getSectionsCount() -> Int
    func getCellsCountFor(section: Int) -> Int
    func cellPressed(type: MainPresenter.CellType, row: Int)
    func configurateCell(_ cell: CurrentAffirmationsTableViewCellProtocol, item: Int)
    func configurateCell(_ cell: LockedAffirmationsTableViewCellProtocol, item: Int)
}

class MainPresenter: MainPresenterProtocol {
    
    private unowned let view: MainViewControllerProtocol
    
    required init(view: MainViewControllerProtocol) {
        self.view = view
    }
    
    // MARK: Local Types
    enum CellType {
        case openedAffirm
        case closedAffirm
    }
    
    // MARK: - Private Properties
    var categories = DatabaseHelper().getCategories()
    
    // MARK:  UI
    func getCellTypeFor(section: Int) -> CellType {
        if section == 0 {
            return .openedAffirm
        } else {
            return .closedAffirm
        }
    }
    
    func getSectionsCount() -> Int {
        return 2
    }
    
    func getCellsCountFor(section: Int) -> Int {
        if section == 0 {
            return categories.count
        } else {
            return 5
        }
    }
    
    func configurateCell(_ cell: CurrentAffirmationsTableViewCellProtocol, item: Int) {
        let category = categories[item]
        
        cell.display(image: "", currentDay: Int(category.currentDay), name: category.categoryName ?? "No Name")
    }
    
    func configurateCell(_ cell: LockedAffirmationsTableViewCellProtocol, item: Int) {
        cell.display(image: "", name: "Affirmation \(item)")
    }
    
    // MARK: - Actions
    func cellPressed(type: MainPresenter.CellType, row: Int) {
        switch type {
        case .openedAffirm:
            DispatchQueue.main.async {
                let vc = AffirmationViewController.instance(.affirmations)
                vc.modalPresentationStyle = .fullScreen
                vc.category = self.categories[row]
                self.view.presentVC(vc, animated: true)
            }
        case .closedAffirm:
            print("closed")
        }
    }
    
}
