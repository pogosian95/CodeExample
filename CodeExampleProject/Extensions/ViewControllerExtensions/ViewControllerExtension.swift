
import UIKit

extension UIViewController {
    
    class func instance(_ storyboard: UIStoryboard.Storyboard) -> Self {
        let storyboard = UIStoryboard(storyboard: storyboard)
        let viewController = storyboard.instantiateViewController(self)
        
        return viewController
    }
    
}
