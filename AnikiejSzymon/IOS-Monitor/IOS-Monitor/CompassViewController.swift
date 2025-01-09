import UIKit

// compass: https://www.flaticon.com/free-icon/compass_1218751?related_id=1218700&origin=search
// arrow: https://www.flaticon.com/free-icons/right


class CompassViewController: UIViewController {
        
    init(degrees: CGFloat) {
        self.degrees = degrees
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var degrees: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCompass()
    }
    
    private func setupCompass() {
        // Compass background image
        let compassBackground = UIImageView(image: UIImage(named: "compass"))
        compassBackground.contentMode = .scaleAspectFit
        compassBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(compassBackground)
        
        // Compass needle image
        let needle = UIImageView(image: UIImage(named: "arrow_south"))
        needle.contentMode = .scaleAspectFit
        needle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(needle)
        
        // Center both images
        NSLayoutConstraint.activate([
            compassBackground.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            compassBackground.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            compassBackground.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            compassBackground.heightAnchor.constraint(equalTo: compassBackground.widthAnchor),
            
            needle.centerXAnchor.constraint(equalTo: compassBackground.centerXAnchor),
            needle.centerYAnchor.constraint(equalTo: compassBackground.centerYAnchor),
            needle.widthAnchor.constraint(equalTo: compassBackground.widthAnchor, multiplier: 0.7),
            needle.heightAnchor.constraint(equalTo: needle.widthAnchor)
        ])
        
        // Rotate the needle
        let angleInRadians = degrees * .pi / 180 // Convert degrees to radians
        needle.transform = CGAffineTransform(rotationAngle: angleInRadians)
    }
}
