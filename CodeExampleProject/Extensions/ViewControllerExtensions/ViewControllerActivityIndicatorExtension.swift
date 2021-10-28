
import UIKit

extension UIViewController {
    
    var activityIndicatorTag: Int { return 999999 }
    var activityBackgroundTag: Int { return 999998 }
    var backgroundTag: Int { return 999997 }
    
    func startActivityIndicator() {
        DispatchQueue.main.async {
            if self.view.viewWithTag(self.backgroundTag) == nil {
                UIApplication.shared.beginIgnoringInteractionEvents()
                DispatchQueue.main.async  {
                    let location = self.view.center
                    
                    let background = UIView(frame: CGRect(origin: location, size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)))
                    background.backgroundColor = .white
                    background.alpha = 0.9
                    background.center = location
                    background.tag = self.backgroundTag
                    
                    let indicatorBackground = UIView(frame: CGRect(origin: location, size: CGSize(width: 80, height: 80)))
                    indicatorBackground.center = location
                    indicatorBackground.backgroundColor = UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 0.6)
                    indicatorBackground.viewCorner(10)
                    indicatorBackground.tag = self.activityBackgroundTag
                    
                    let activityIndicator = UIActivityIndicatorView(style: .white)
                    activityIndicator.color = .lightGray
                    activityIndicator.center = location
                    activityIndicator.tag = self.activityIndicatorTag
                    activityIndicator.hidesWhenStopped = true
                    activityIndicator.startAnimating()
                    
                    self.view.addSubview(background)
                    self.view.addSubview(indicatorBackground)
                    self.view.addSubview(activityIndicator)
                }
            }
        }
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async  {
            if let background = self.view.viewWithTag(self.backgroundTag),
               let backgroundIndicator = self.view.viewWithTag(self.activityBackgroundTag),
               let activityIndicator = self.view.viewWithTag(self.activityIndicatorTag) as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                backgroundIndicator.removeFromSuperview()
                background.removeFromSuperview()
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
    }
    
}
