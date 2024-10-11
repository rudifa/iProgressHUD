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

    private var huds = Huds()

    @IBOutlet private var view2: UIImageView!
    @IBOutlet private var view3: UIImageView!

    private var horizontal = false

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
        view2.isHidden = false
        view3.isHidden = false
    }

    private func setupGestureRecognizers() {
        let doubleTapGesture = UITapGestureRecognizer(
            target: self, action: #selector(handleDoubleTapGesture)
        )
        doubleTapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapGesture)

        // Swipe gesture recognizers
        let directions: [UISwipeGestureRecognizer.Direction] = [.up, .down, .left, .right]
        for direction in directions {
            let swipeGesture = UISwipeGestureRecognizer(
                target: self, action: #selector(handleSwipeGesture)
            )
            swipeGesture.direction = direction
            view.addGestureRecognizer(swipeGesture)
        }
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

    // Dismiss the current progress HUD and show the HUD for the current index
    private func showCurrentHUD() {
        view.dismissProgress()
        attachProgressHUD(indicatorStyle: huds.type)
    }

    // Create, configure and attach the progress HUD with the specified indicator style
    private func attachProgressHUD(indicatorStyle: NVActivityIndicatorType) {
        // Create a new instance of iProgressHUD
        let iprogress = iProgressHUD()

        // Set the delegate to self
        iprogress.delegate = self

        // Configure the progress HUD properties
        iprogress.iprogressStyle = horizontal ? .horizontal : .vertical
        iprogress.indicatorStyle = indicatorStyle
        iprogress.isShowModal = false
        iprogress.boxSize = 50
        iprogress.captionText = "\(indicatorStyle)"
        iprogress.boxColor = .lightGray
        iprogress.indicatorColor = .white
        iprogress.modalColor = .black.withAlphaComponent(0.3)

        // Attach the progress HUD to the view and show it
        iprogress.attachProgress(toView: view)
        view.showProgress()
    }

    // Show the next or previous HUD based on the 'next' parameter
    private func showNextOrPrevHUD(next: Bool) {
        huds.next(next)
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

    @objc private func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .up:
            huds.next(true)
        case .down:
            huds.next(false)
        case .left, .right:
            horizontal.toggle()
        default:
            break
        }
        showCurrentHUD()
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

// MARK: - iProgressHUDDelegate

extension ViewController1: iProgressHUDDelegate {
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
