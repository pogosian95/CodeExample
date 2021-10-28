
import UIKit

protocol BaseViewControllerProtocol: AnyObject {
    
    func startActivityIndicator()
    func stopActivityIndicator()
    func popToRootVC(animated: Bool)
    func popToVC(_ vc: UIViewController.Type, animated: Bool)
    func popVC(animated: Bool)
    func pushToVC(_ vc: UIViewController, animated: Bool)
    func presentVC(_ vc: UIViewController, animated: Bool)
    func changeRootVC(_ vc: UIViewController)
    func dismiss(animated: Bool)
    func gotoTabBatItem(_ item: Int)
}
