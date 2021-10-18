
import UIKit

extension String {
    
    func convertDateTo(_ format: String, showToday: Bool) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateFromInputString = dateFormatter.date(from: self)
        dateFormatter.dateFormat = format
        
        if dateFromInputString != nil {
            if Calendar.current.isDateInToday(dateFromInputString!) && showToday {
                dateFormatter.dateFormat = "HH:mm"
                return "Today \(dateFormatter.string(from: dateFromInputString!))"
            }
            return dateFormatter.string(from: dateFromInputString!)
        }
        else{
            return "Invalid input date format"
        }
    }
    
}

extension NSMutableAttributedString {
    
    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
    
}
