
import UIKit

extension UIViewController {
    
    class func instance(_ storyboard: UIStoryboard.Storyboard) -> Self {
        let storyboard = UIStoryboard(storyboard: storyboard)
        let viewController = storyboard.instantiateViewController(self)
        
        return viewController
    }
    
    func showErrorAlert(_ error: String) {
        showAlert(title: "Error", message: error, completion: nil, type: .alert)
    }
    
    func showSuccessAlert(_ message: String?) {
        showAlert(title: "Success", message: message, completion: nil, type: .alert)
    }
    
    func choiceAlert(title: String?, message: String?, type: UIAlertController.Style = .alert, customAction: [UIAlertAction], completion: (() -> Void)? = nil) {
        showAlert(title: title, message: message, customActions: customAction, completion: completion, type: type)
    }
    
    func showAlert(title: String?, message: String?, customActions: [UIAlertAction] = [], completion: (() -> Void)?, type: UIAlertController.Style = .alert) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: type)
            
            if customActions.isEmpty {
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            } else {
                for action in customActions {
                    alert.addAction(action)
                }
            }
            
            self.present(alert, animated: true, completion: completion)
        }
    }
    
    func setupSearchBar(searchController: UISearchController, barButtonItems: Bool, rightBarButtonItem: UIBarButtonItem?, rightBarButtonItems: [UIBarButtonItem]?, hideNavigationBar: Bool) {
        let vc = self
        navigationItem.searchController = searchController
        if barButtonItems {
            navigationItem.rightBarButtonItems = rightBarButtonItems
        } else {
            navigationItem.rightBarButtonItem = rightBarButtonItem
        }
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = vc as? UISearchResultsUpdating
        searchController.searchBar.delegate = vc as? UISearchBarDelegate
        if hideNavigationBar {
            searchController.hidesNavigationBarDuringPresentation = false
        }
    }
    
}
