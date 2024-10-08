import iProgressHUD
import UIKit

class ViewController2: UIViewController, iProgressHUDDelegete {
    let label = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()

        greetingsLabel()

        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        view.addGestureRecognizer(tapGesture)
    }

    override func viewDidAppear(_: Bool) {
        super.viewDidAppear(true)

        let iprogress = iProgressHUD()
        iprogress.delegete = self
        iprogress.iprogressStyle = .horizontal
        iprogress.indicatorStyle = .orbit
        iprogress.isShowModal = false
        iprogress.boxSize = 50

        iprogress.attachProgress(toViews: view) // , view1, view2, view3)
        view.showProgress()
    }

    func greetingsLabel() {
        label.text = "Hello World\nfrom iProgressHUD SwiftPM package!"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16.0)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 10),
        ])

        for itype in NVActivityIndicatorType.allTypes {
            // Append the itype to the label's text
            label.text! += "\n\(itype)"
        }
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

    func updateLabel(with itype: String) {
        // Append the itype to the label's text
        label.text = (label.text ?? "") + "\n" + String(describing: itype)
    }

    func onShow(view _: UIView) {}

    func onDismiss(view _: UIView) {}
}
