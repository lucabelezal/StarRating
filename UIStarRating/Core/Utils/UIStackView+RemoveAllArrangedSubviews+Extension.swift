import UIKit

extension UIStackView {
    func removeAllArrangedSubviews() {
        subviews.forEach {
            $0.removeFromSuperview()
            removeArrangedSubview($0)
        }
    }
}
