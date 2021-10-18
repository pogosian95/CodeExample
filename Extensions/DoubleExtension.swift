
import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(digit: Int) -> Double {
        let divisor = pow(10.0, Double(digit))
        return (self * divisor).rounded(.down) / divisor
    }
}
