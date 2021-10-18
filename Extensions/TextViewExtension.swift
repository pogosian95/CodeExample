
import UIKit

extension UITextView {
    
    func hyperLink(originalText: String, hyperLink: [String], urlString: [String], styleAligment: NSTextAlignment, fontSize: CGFloat = 17, textColor: UIColor = .systemBlue) {
        
        let style = NSMutableParagraphStyle()
        style.alignment = styleAligment
        let attributedOriginalText = NSMutableAttributedString(string: originalText, attributes: [ NSAttributedString.Key.paragraphStyle: style,
              NSAttributedString.Key.font : UIFont.systemFont(ofSize: fontSize, weight: .regular),
              NSAttributedString.Key.foregroundColor : textColor])
        
        for i in 0..<hyperLink.count {
            let linkRange = attributedOriginalText.mutableString.range(of: hyperLink[i])
            attributedOriginalText.addAttribute(NSAttributedString.Key.link, value: urlString[i], range: linkRange)
        }
        
        self.linkTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.blue,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: fontSize, weight: .regular)]
        
        self.attributedText = attributedOriginalText
    }
    
}
