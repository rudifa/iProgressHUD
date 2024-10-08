//
//  ViewController1.swift
//  SPMDemo
//
//  Created by Rudolf Farkas on 04.10.2024.
//
//  Created by Rudolf Farkas on 04.10.2024.
//

import iProgressHUD
import UIKit

class ViewController1: UIViewController, iProgressHUDDelegete {
    let label = UILabel()

    @IBOutlet var view2: UIImageView!
    @IBOutlet var view3: UIImageView!

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

        // Find the index of .orbit in NVActivityIndicatorType.allTypes
        let orbitIndex = NVActivityIndicatorType.allTypes.firstIndex(of: .orbit) ?? 0

        // Set the initial HUD type index to the orbit index in UserDefaults
        UserDefaults.standard.set(orbitIndex, forKey: "currentHUDTypeIndex")

        // Ensure view2 and view3 are visible
        view2.isHidden = false
        view3.isHidden = false

        // Add tap gesture recognizer to the main view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        view.addGestureRecognizer(tapGesture)
    }

    override func viewDidAppear(_: Bool) {
        super.viewDidAppear(true)

        greetings()

        // Dismiss any existing HUD
        view.dismissProgress()

        // Recover the current index and apply the corresponding HUD style
        let indicatorType = NVActivityIndicatorType.allTypes[currentIndex]
        setupProgressHUD(indicatorStyle: indicatorType)

        showAndFadeOutViews()
    }

    func showAndFadeOutViews() {
        // Show views
        view2.isHidden = false
        view3.isHidden = false
        view2.alpha = 1.0
        view3.alpha = 1.0

        // Animate fade out
        UIView.animate(
            withDuration: 5.0,
            delay: 0.5,
            options: .curveEaseOut,
            animations: {
                self.view2.alpha = 0.0
                self.view3.alpha = 0.0
            },
            completion: { _ in
                self.view2.isHidden = true
                self.view3.isHidden = true
            }
        )
    }

    func greetings() {
        label.text = "Hello World\nfrom iProgressHUD SwiftPM package!"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16.0)
        label.textColor = .gray
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
        ])
    }

    @objc func handleTapGesture() {
        // Perform segue to ViewController2
        performSegue(withIdentifier: "toViewController2", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == "toViewController2" {
            // Dismiss any existing HUD
            view.dismissProgress()
            // Pass any data to ViewController2 if needed
        }
    }

    @IBAction func unwindToViewController1(segue _: UIStoryboardSegue) {
        showAndFadeOutViews()
    }

    func onShow(view _: UIView) {
        // a delegate func, do not remove!
    }

    func onDismiss(view _: UIView) {
        // a delegate func, do not remove!
    }

    // MARK: - Present one HUD type

    // Setup Progress HUD for ViewController1
    func setupProgressHUD(indicatorStyle: NVActivityIndicatorType) {
        let iprogress = iProgressHUD()
        iprogress.delegete = self
        iprogress.iprogressStyle = .vertical // Vertical style for ViewController1
        iprogress.indicatorStyle = indicatorStyle
        iprogress.isShowModal = false // Modal HUD for ViewController1
        iprogress.boxSize = 50

        // Additional settings for ViewController1
        iprogress.boxColor = .lightGray
        iprogress.indicatorColor = .white
        iprogress.modalColor = .black.withAlphaComponent(0.3)

        iprogress.attachProgress(toView: view)
        view.showProgress()
    }
}
