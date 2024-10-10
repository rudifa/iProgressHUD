//
//  ViewController1.swift
//  SPMDemo
//
//  Created by Rudolf Farkas on 04.10.2024.
//

import iProgressHUD
import UIKit

class ViewController1: UIViewController {
    // MARK: - Properties

    private var allTypes: [NVActivityIndicatorType] {
        NVActivityIndicatorType.allTypes
    }

    @IBOutlet private var view2: UIImageView!
    @IBOutlet private var view3: UIImageView!

    private var currentIndex: Int {
        get { UserDefaults.standard.integer(forKey: "currentHUDTypeIndex") }
        set { UserDefaults.standard.set(newValue, forKey: "currentHUDTypeIndex") }
    }

    private lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16.0)
        label.textColor = .gray
        return label
    }()

    private enum Const {
        static let greetingText = "Hello World\nfrom iProgressHUD SwiftPM package!"
        static let hudBoxSize: CGFloat = 50
        static let fadeOutDuration: TimeInterval = 5.0
        static let fadeOutDelay: TimeInterval = 0.5
    }

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialState()
        setupGestureRecognizers()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUI()
        showCurrentHUD()
        showAndFadeOutViews()
    }

    // MARK: - Setup Methods

    private func setupInitialState() {
        let orbitIndex = NVActivityIndicatorType.allTypes.firstIndex(of: .orbit) ?? 0
        UserDefaults.standard.set(orbitIndex, forKey: "currentHUDTypeIndex")
        view2.isHidden = false
        view3.isHidden = false
    }

    private func setupGestureRecognizers() {
        let doubleTapGesture = UITapGestureRecognizer(
            target: self, action: #selector(handleDoubleTapGesture)
        )
        doubleTapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapGesture)

        let rightSwipeGesture = UISwipeGestureRecognizer(
            target: self, action: #selector(handleSwipeGestures)
        )
        rightSwipeGesture.direction = .right
        view.addGestureRecognizer(rightSwipeGesture)

        let leftSwipeGesture = UISwipeGestureRecognizer(
            target: self, action: #selector(handleSwipeGestures)
        )
        leftSwipeGesture.direction = .left
        view.addGestureRecognizer(leftSwipeGesture)
    }

    private func setupUI() {
        setupGreetingsLabel()
    }

    private func setupGreetingsLabel() {
        label.text = Const.greetingText
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
        ])
    }

    // MARK: - HUD Management

    private func showCurrentHUD() {
        view.dismissProgress()
        let indicatorType = NVActivityIndicatorType.allTypes[currentIndex]
        setupProgressHUD(indicatorStyle: indicatorType)
    }

    private func setupProgressHUD(indicatorStyle: NVActivityIndicatorType) {
        let iprogress = iProgressHUD()
        iprogress.delegete = self
        iprogress.iprogressStyle = .vertical
        iprogress.indicatorStyle = indicatorStyle
        iprogress.isShowModal = false
        iprogress.boxSize = 50
        iprogress.captionText = "\(indicatorStyle)"
        iprogress.boxColor = .lightGray
        iprogress.indicatorColor = .white
        iprogress.modalColor = .black.withAlphaComponent(0.3)

        iprogress.attachProgress(toView: view)
        view.showProgress()
    }

    private func showAnotherIndicator(next: Bool) {
        let count = allTypes.count
        currentIndex = (currentIndex + (next ? 1 : count - 1)) % count
        showCurrentHUD()
    }

    // MARK: - UI Animations

    private func showAndFadeOutViews() {
        view2.isHidden = false
        view3.isHidden = false
        view2.alpha = 1.0
        view3.alpha = 1.0

        UIView.animate(
            withDuration: Const.fadeOutDuration, delay: Const.fadeOutDelay,
            options: .curveEaseOut
        ) { [weak self] in
            [self?.view2, self?.view3].forEach { $0?.alpha = 0.0 }
        } completion: { [weak self] _ in
            [self?.view2, self?.view3].forEach { $0?.isHidden = true }
        }
    }

    // MARK: - Gesture Handlers

    @objc private func handleDoubleTapGesture() {
        print("double tap gesture")
        performSegue(withIdentifier: "toViewController2", sender: self)
    }

    @objc private func handleSwipeGestures(sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .left:
            showAnotherIndicator(next: true)
        case .right:
            showAnotherIndicator(next: false)
        default:
            break
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == "toViewController2" {
            view.dismissProgress()
            // Pass any data to ViewController2 if needed
        }
    }

    @IBAction func unwindToViewController1(segue _: UIStoryboardSegue) {
        print("unwound to vc1")
        showAndFadeOutViews()
    }
}

// MARK: - iProgressHUDDelegete

extension ViewController1: iProgressHUDDelegete {
    func onTouch(view: UIView) {
        print("VC1: HUD touched on \(type(of: view)) at \(Date())")
    }

    func onShow(view: UIView) {
        print("VC1: HUD shown on \(type(of: view)) at \(Date())")
    }

    func onDismiss(view: UIView) {
        print("VC1: HUD dismissed from \(type(of: view)) at \(Date())")
    }
}
