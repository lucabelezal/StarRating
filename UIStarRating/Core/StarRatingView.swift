import UIKit

internal class StarRatingView: UIView {
    // MARK: - Subtypes -
    
    private enum Constants {
        static let unselectedStarImage = UIImage(systemName: "star")
        static let selectedStarImage = UIImage(systemName: "star.fill")
    }
    
    // MARK: - Public Computed Instance Properties -
    
    internal var isSelected = false {
        didSet {
            imageView.image = isSelected ? Constants.selectedStarImage : Constants.unselectedStarImage
        }
    }
    
    // MARK: - Private Computed Instance Properties -
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: Constants.unselectedStarImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Initializers -
    
    internal init() {
        super.init(frame: .zero)
        setupView()
    }
    
    @available(*, unavailable)
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods -
    
    private func setupView() {
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
