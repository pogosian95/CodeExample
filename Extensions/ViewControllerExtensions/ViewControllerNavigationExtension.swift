
import UIKit

extension UIViewController {
    
    func popToRootVC(animated: Bool) {
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: animated)
        }
    }
    
    func popToVC(_ vc: UIViewController.Type, animated: Bool) {
        DispatchQueue.main.async {
            guard let controllers = self.navigationController?.viewControllers else {
                #if DEBUG
                print("Do not have controllers")
                #endif
                return
            }
            
            for controller in controllers {
                if controller.isKind(of: vc.self) {
                    self.navigationController?.popToViewController(controller, animated: true)
                    break
                }
            }
        }
    }
    
    func popVC(animated: Bool) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: animated)
        }
    }
    
    func pushToVC(_ vc: UIViewController, animated: Bool) {
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func presentVC(_ vc: UIViewController, animated: Bool) {
        DispatchQueue.main.async {
            self.present(vc, animated: animated, completion: nil)
        }
    }
    
    func dismiss(animated: Bool) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func changeRootVC(_ vc: UIViewController) {
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController = vc
        }
    }
    
    func gotoTabBatItem(_ item: Int) {
        DispatchQueue.main.async {
            self.tabBarController?.selectedIndex = item
        }
    }
    
}
