
import UIKit

class LabelWithInsets: UILabel {
    
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top, left: -textInsets.left, bottom: -textInsets.bottom, right: -textInsets.right)
        
        return textRect.inset(by: invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
}


extension UIViewController {
    
    var infoToastTag: Int { return 999996 }
    var errorToastTag: Int { return 999995 }
    var buttonToastTag: Int { return 999994 }
    
    @objc func closeToast() {
        self.view.viewWithTag(infoToastTag)?.removeFromSuperview()
        self.view.viewWithTag(errorToastTag)?.removeFromSuperview()
        self.view.viewWithTag(buttonToastTag)?.removeFromSuperview()
    }
    
    func showInfoToast(message : String) { //добавить высоту таббара
        
        DispatchQueue.main.async {
            let label = LabelWithInsets()
            label.tag = self.infoToastTag
            label.backgroundColor = .secondarySystemBackground
//            label.textColor = .appColor(.backgroundVC)
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 13)
            label.alpha = 0.85
            label.text = message
            label.clipsToBounds = true
            label.viewCorner(10)
            label.numberOfLines = 0
            label.textInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
            label.translatesAutoresizingMaskIntoConstraints = false
            
            let button = UIButton()
            button.addTarget(self, action: #selector(self.closeToast), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = self.buttonToastTag
            
            self.view.addSubview(label)
            self.view.addSubview(button)
            
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -20 - ((self.tabBarController?.tabBar.isHidden ?? true) ? 0 : self.tabBarController?.tabBar.frame.size.height ?? 0)),
                NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 56),
                NSLayoutConstraint(item: label, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: -55),
                NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -20),
                NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 56),
                NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: -55),
                NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: label, attribute: .top, multiplier: 1, constant: 0)
            ])
            
            UIView.animate(withDuration: 1, delay: 1.5, options: .curveEaseIn, animations: {
                label.alpha = 0
            }, completion: {(isCompleted) in
                label.removeFromSuperview()
                button.removeFromSuperview()
            })
        }
        
    }
    
    func showErrorToast(message: String) {
        
        DispatchQueue.main.async {
            let backgroundView = UIView()
            backgroundView.tag = self.errorToastTag
            backgroundView.backgroundColor = .secondarySystemBackground
            backgroundView.viewCorner(10)
            backgroundView.translatesAutoresizingMaskIntoConstraints = false
            backgroundView.alpha = 1
            let errorImage = UIImageView(image: .appImage(.textAffirmIcon))
            errorImage.frame.size.width = 14
            errorImage.frame.size.height = 13
            errorImage.translatesAutoresizingMaskIntoConstraints = false
            let label = UILabel()
            label.backgroundColor = .clear
//            label.textColor = .appColor(.backgroundVC)
            label.textAlignment = .left
            label.font = UIFont.systemFont(ofSize: 13)
            label.alpha = 1
            label.text = message
            label.clipsToBounds = true
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            label.sizeToFit()
            
            let button = UIButton()
            button.addTarget(self, action: #selector(self.closeToast), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = .clear
            button.tag = self.buttonToastTag
            
            backgroundView.addSubview(errorImage)
            backgroundView.addSubview(label)
            self.view.addSubview(backgroundView)
            self.view.addSubview(button)
            
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: errorImage, attribute: .left, relatedBy: .equal, toItem: backgroundView, attribute: .left, multiplier: 1, constant: 15),
                NSLayoutConstraint(item: errorImage, attribute: .centerY, relatedBy: .equal, toItem: backgroundView, attribute: .centerY, multiplier: 1, constant: 1),
                
                NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: backgroundView, attribute: .top, multiplier: 1, constant: 15),
                NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: errorImage, attribute: .right, multiplier: 1, constant: 10),
                NSLayoutConstraint(item: label, attribute: .right, relatedBy: .equal, toItem: backgroundView, attribute: .right, multiplier: 1, constant: -16),
                NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: backgroundView, attribute: .bottom, multiplier: 1, constant: -15),
                
                NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: backgroundView, attribute: .top, multiplier: 1, constant: 1),
                NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: backgroundView, attribute: .left, multiplier: 1, constant: 1),
                NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: backgroundView, attribute: .right, multiplier: 1, constant: 1),
                NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: backgroundView, attribute: .bottom, multiplier: 1, constant: 1),
                
                NSLayoutConstraint(item: backgroundView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: backgroundView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 56),
                NSLayoutConstraint(item: backgroundView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: -55)
            ])
            
            UIView.animate(withDuration: 1, delay: 3, options: .curveEaseIn, animations: {
                backgroundView.alpha = 0
            }, completion: {(isCompleted) in
                backgroundView.removeFromSuperview()
                button.removeFromSuperview()
            })
            
        }
        
    }
}
