import iProgressHUD
import UIKit

class ViewController2: UIViewController, iProgressHUDDelegete {
    let hudTypesLabel = UILabel()

    private var currentIndex: Int {
        get {
            UserDefaults.standard.integer(forKey: "currentHUDTypeIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "currentHUDTypeIndex")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupHudTypesLabel()

        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        view.addGestureRecognizer(tapGesture)
    }

    override func viewDidAppear(_: Bool) {
        super.viewDidAppear(true)

        presentAllTypes()
    }

    @objc func handleTapGesture() {
        // Check if ViewController2 is presented modally
        if presentingViewController != nil {
            // Dismiss ViewController2 and then perform unwind segue to ViewController1
            dismiss(animated: true) {
                self.performSegue(withIdentifier: "unwindToViewController1", sender: self)
            }
        } else {
            fatalError(
                "ViewController2 should be presented modally.")
        }
    }

    // MARK: present all HUD types

    func setupHudTypesLabel() {
        hudTypesLabel.text = ""
        hudTypesLabel.numberOfLines = 0
        hudTypesLabel.textAlignment = .center
        hudTypesLabel.font = .systemFont(ofSize: 16.0)
        hudTypesLabel.textColor = .lightGray
        view.addSubview(hudTypesLabel)
        hudTypesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hudTypesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hudTypesLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30
            ),
        ])

        for itype in NVActivityIndicatorType.allTypes {
            // Append the itype to the label's text
            hudTypesLabel.text! += "\n\(itype)"
        }
    }

    // Setup Progress HUD for ViewController2
    // Note: This configuration is different from ViewController1 for demonstration purposes
    // In a production app, you might want to create a shared configurator for consistency
    func setupProgressHUD(indicatorStyle: NVActivityIndicatorType) {
        let iprogress = iProgressHUD()
        iprogress.delegete = self
        iprogress.iprogressStyle = .horizontal // Different from VC1 to show various styles
        iprogress.indicatorStyle = indicatorStyle
        iprogress.isShowModal = false // Different from VC1 to demonstrate non-modal HUD
        iprogress.boxSize = 50

        iprogress.attachProgress(toView: view)
        view.showProgress()
    }

    func presentAllTypes() {
        presentNextIndicatorType(index: currentIndex)
    }

    func presentNextIndicatorType(index: Int) {
        let count = NVActivityIndicatorType.allTypes.count
        currentIndex = index % count // This will now save to UserDefaults
        let itype = NVActivityIndicatorType.allTypes[currentIndex]
        setupProgressHUD(indicatorStyle: itype)

        // Update the label with the current type highlighted
        updateHudTypesLabel(highlightedType: itype)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.view.dismissProgress()
            self.presentNextIndicatorType(index: index + 1)
        }
    }

    func updateHudTypesLabel(highlightedType: NVActivityIndicatorType) {
        let attributedString = NSMutableAttributedString()

        for itype in NVActivityIndicatorType.allTypes {
            let typeString = "\n\(itype)"
            let attributes: [NSAttributedString.Key: Any] = [
                .font: itype == highlightedType
                    ? UIFont.boldSystemFont(ofSize: 16.0) : UIFont.systemFont(ofSize: 16.0),
                .foregroundColor: itype == highlightedType ? UIColor.blue : UIColor.lightGray,
            ]
            attributedString.append(NSAttributedString(string: typeString, attributes: attributes))
        }

        hudTypesLabel.attributedText = attributedString
    }
}
