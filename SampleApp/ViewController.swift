import UIKit
import UIStarRating

class ViewController: UIViewController {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var ratingControl: StarRatingControl = {
        let control = StarRatingControl(totalStars: 5)
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        view.addSubview(ratingControl)
        NSLayoutConstraint.activate([
            ratingControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ratingControl.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: ratingControl.bottomAnchor, constant: 16),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
        
    @objc
    private func valueChanged(_ sender: StarRatingControl) {
        print("\(sender.ratingValue)")
        label.text = "\(sender.ratingValue)"
    }
}

