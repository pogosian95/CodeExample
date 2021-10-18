
import Foundation

extension Collection {
    subscript(index i : Index) -> Element? {
        return indices.contains(i) ? self[i] : nil
    }
}
