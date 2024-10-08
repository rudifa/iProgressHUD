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

    override func viewDidLoad() {
        super.viewDidLoad()
        view2.isHidden = false
        view3.isHidden = false

        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        view.addGestureRecognizer(tapGesture)
    }

    override func viewDidAppear(_: Bool) {
        super.viewDidAppear(true)

        greetings()

        let iprogress = iProgressHUD()
        iprogress.delegete = self
        iprogress.iprogressStyle = .horizontal
        iprogress.indicatorStyle = .orbit
        iprogress.isShowModal = false
        iprogress.boxSize = 50

        iprogress.attachProgress(toViews: view)
        view.showProgress()

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
            // Pass any data to ViewController2 if needed
        }
    }

    @IBAction func unwindToViewController1(segue _: UIStoryboardSegue) {
        showAndFadeOutViews()
    }

    func onShow(view _: UIView) {}

    func onDismiss(view _: UIView) {}
}
