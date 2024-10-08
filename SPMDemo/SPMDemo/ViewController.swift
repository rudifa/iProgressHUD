//
//  ViewController.swift
//  SPMDemo
//
//  Created by Rudolf Farkas on 04.10.2024.
//

import iProgressHUD
import UIKit

class ViewController: UIViewController, iProgressHUDDelegete {
//    @IBOutlet var view3: UIView!
//    @IBOutlet var view2: UIView!
//    @IBOutlet var view1: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
//        view1.isHidden = true
//        view2.isHidden = true
//        view3.isHidden = true
    }

    override func viewDidAppear(_: Bool) {
//        iProgressHUD.sharedInstance().attachProgress(toView: self.view)
//        self.view.showProgress()

        greetings()

        let iprogress = iProgressHUD()
        iprogress.delegete = self
        iprogress.iprogressStyle = .horizontal
        iprogress.indicatorStyle = .orbit
        iprogress.isShowModal = false
        iprogress.boxSize = 50

        iprogress.attachProgress(toViews: view) // , view1, view2, view3)
        view.showProgress()
//        view1.showProgress()
//        view2.showProgress()
//        view3.showProgress()
    }

    func greetings() {
        let label = UILabel()
        label.text = "Hello World\nfrom iProgressHUD SwiftPM package!"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16.0)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 4),

        ])
    }

    func onShow(view _: UIView) {
        print("onShow")
    }

    func onDismiss(view _: UIView) {
        print("onDismiss")
    }

    func onTouch(view _: UIView) {
        print("onTouch")
    }
}
