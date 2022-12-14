import UIKit

public class StarRatingControl: UIControl {
    // MARK: - Subtypes -
    
    private enum Constants {
        static let minStarsValue = 3
        static let maxStarsValue = 10
        static let defaultRatingValue = 0
        static let starsSpacing = 10
    }
    
    // MARK: - Public Computed Instance Properties -
    
    public var maximumStarsValue: Int {
        get { _maximumStarsValue }
        set {
            let minimumValue = max(newValue, Constants.minStarsValue)
            _maximumStarsValue = min(minimumValue, Constants.maxStarsValue)
            _ratingValue = min(_ratingValue, _maximumStarsValue)
        }
    }
    
    public var ratingValue: Int {
        get { _ratingValue }
        set {
            let minValue = max(newValue, Constants.defaultRatingValue)
            _ratingValue = min(minValue, _maximumStarsValue)
        }
    }
    
    // MARK: - Private Computed Instance Properties -
    
    private var _maximumStarsValue: Int = Constants.minStarsValue {
        didSet {
            if maximumStarsValue != oldValue { reloadView() }
        }
    }
    
    private var _ratingValue: Int = Constants.defaultRatingValue {
        didSet {
            guard let stars = contentStack.arrangedSubviews as? [StarRatingView] else { return }
            for (index, star) in stars.enumerated() { star.isSelected = index < _ratingValue }
            updateAccessibility()
            sendActions(for: .valueChanged)
        }
    }
    
    private lazy var contentStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = CGFloat(Constants.starsSpacing)
        return stackView
    }()
    
    // MARK: - Initializers -
    
    public init(totalStars: Int, frame: CGRect = .zero) {
        self._maximumStarsValue = totalStars
        super.init(frame: frame)
        setupView()
        setupAccessibility()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Override Methods -
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        rate(with: touches, event: event)
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        rate(with: touches, event: event)
    }
        
    override public func accessibilityIncrement() {
        super.accessibilityIncrement()
        ratingValue += 1
    }
    
    override public func accessibilityDecrement() {
        super.accessibilityDecrement()
        ratingValue -= 1
    }
    
    // MARK: - Private Methods -
    
    private func setupView() {
        addSubview(contentStack)
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStack.topAnchor.constraint(equalTo: topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        loadView()
    }
    
    private func loadView() {
        for item in 1..._maximumStarsValue {
            let starRatingView = StarRatingView()
            starRatingView.isSelected = item <= _ratingValue
            contentStack.addArrangedSubview(starRatingView)
            starRatingView.widthAnchor.constraint(equalTo: starRatingView.heightAnchor).isActive = true
        }
    }
    
    private func reloadView() {
        contentStack.removeAllArrangedSubviews()
        loadView()
    }
    
    private func rate(for star: StarRatingView) -> Int {
        (contentStack.arrangedSubviews.firstIndex(of: star) ?? 0) + 1
    }
    
    private func rate(with touches: Set<UITouch>, event: UIEvent?) {
        guard let touchLocation = touches.first?.location(in: contentStack) else { return }
        let centeredLocation = CGPoint(x: touchLocation.x, y: contentStack.frame.midY)
        guard let star = contentStack.hitTest(centeredLocation, with: event) as? StarRatingView else { return }
        ratingValue = rate(for: star)
    }
    
    // MARK: - Accessibility -
    
    private func setupAccessibility() {
        isAccessibilityElement = true
        accessibilityTraits = .adjustable
        accessibilityLabel = NSLocalizedString(
            "starRatingControl",
            bundle: Bundle(for: Self.self),
            comment: ""
        )
        updateAccessibility()
    }
    
    private func updateAccessibility() {
        let localizedFormat = NSLocalizedString(
            "stars",
            bundle: Bundle(for: Self.self),
            comment: ""
        )
        accessibilityValue = String.localizedStringWithFormat(localizedFormat, _ratingValue)
    }
}
