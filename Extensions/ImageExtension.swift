
import UIKit

extension UIImage {
    
    enum AssetImage: String {
        
        case textAffirmIcon
    }
    
    static func appImage(_ name: AssetImage) -> UIImage {
        
        guard let image = UIImage(named: name.rawValue) else {
            print("Error: image \(name.rawValue) not found")
            return UIImage()
        }
        
        return image
    }
}
