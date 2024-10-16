//
//  ViewController.swift
//  iProgressHUDDemo
//
//  Created by Saiful I. Wicaksana on 12/01/18.
//  Copyright © 2018 icaksama. All rights reserved.
//

import iProgressHUD
import UIKit

class ViewController: UIViewController, iProgressHUDDelegate {
    @IBOutlet var view3: UIView!
    @IBOutlet var view2: UIView!
    @IBOutlet var view1: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view1.isHidden = true
        view2.isHidden = false
        view3.isHidden = false

        addGreetingsLabel()
    }

    override func viewDidAppear(_: Bool) {
        let iprogress = iProgressHUD()
        iprogress.delegate = self
        iprogress.iprogressStyle = .vertical
        iprogress.indicatorStyle = .orbit
        iprogress.isShowModal = false
        iprogress.boxSize = 50

        iprogress.attachProgress(toViews: view, view1, view2, view3)
        view.showProgress()
        view1.showProgress()
        view2.showProgress()
        view3.showProgress()
    }

    private func addGreetingsLabel() {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16.0)
        label.textColor = .gray

        let fullText = "Hello World from iProgressHUD\nCocoa pod!"
        let attributedString = NSMutableAttributedString(string: fullText)

        // Define the range for "Cocoa pod!"
        let range = (fullText as NSString).range(of: "Cocoa pod!")

        // Apply a larger font to "Cocoa pod!"
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: range)

        label.attributedText = attributedString
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
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
