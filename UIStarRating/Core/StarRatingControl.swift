import UIKit

public class StarRatingControl: UIControl {
    
    // MARK: - Subtypes -
    
    private enum Constants {
        static let minMaximumValue = 3
        static let maxMaximumValue = 10
        static let defaultValue = 0
        static let starsSpacing = 10
    }
    
    // MARK: - Public Computed Instance Properties -
    
    public var maximumValue: Int {
        get { _maximumValue }
        set {
            let minimumValue = max(newValue, Constants.minMaximumValue)
            _maximumValue = min(minimumValue, Constants.maxMaximumValue)
            _value = min(_value, _maximumValue)
        }
    }
    
    public var value: Int {
        get { _value }
        set {
            let minValue = max(newValue, Constants.defaultValue)
            _value = min(minValue, _maximumValue)
        }
    }
    
    // MARK: - Private Computed Instance Properties -
    
    private var _maximumValue: Int = Constants.minMaximumValue {
        didSet {
            if maximumValue != oldValue { reloadView() }
        }
    }
    
    private var _value: Int = Constants.defaultValue {
        didSet {
            guard let stars = contentStack.arrangedSubviews as? [StarRatingView] else { return }
            for (index, star) in stars.enumerated() { star.isSelected = index < _value }
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
        self._maximumValue = totalStars
        super.init(frame: frame)
        setupView()
        setupAccessibility()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Override Methods -
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        rate(with: touches, event: event)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        rate(with: touches, event: event)
    }
    
    public override func accessibilityIncrement() {
        super.accessibilityIncrement()
        value += 1
    }
    
    public override func accessibilityDecrement() {
        super.accessibilityDecrement()
        value -= 1
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
        for i in 1..._maximumValue {
            let star = StarRatingView()
            star.isSelected = i <= _value
            contentStack.addArrangedSubview(star)
            star.widthAnchor.constraint(equalTo: star.heightAnchor).isActive = true
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
        value = rate(for: star)
    }
    
    // MARK: - Accessibility -
    
    private func setupAccessibility() {
        isAccessibilityElement = true
        accessibilityTraits = .adjustable
        accessibilityLabel = NSLocalizedString(
            "starRatingControl",
            bundle: Bundle.init(for: Self.self),
            comment: ""
        )
        updateAccessibility()
    }
    
    private func updateAccessibility() {
        let localizedFormat = NSLocalizedString(
            "stars",
            bundle: Bundle.init(for: Self.self),
            comment: ""
        )
        accessibilityValue = String.localizedStringWithFormat(localizedFormat, _value)
    }
}
