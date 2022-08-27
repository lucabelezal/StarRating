import UIKit

extension UIStackView {
    internal func removeAllArrangedSubviews() {
        subviews.forEach {
            $0.removeFromSuperview()
            removeArrangedSubview($0)
        }
    }
}
