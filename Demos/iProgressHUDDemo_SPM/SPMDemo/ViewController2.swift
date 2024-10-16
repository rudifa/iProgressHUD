//
//  ViewController2.swift
//  SPMDemo
//
//  Created by Rudolf Farkas on 08.10.2024.
//
import iProgressHUD

import UIKit

class ViewController2: UIViewController {
    // MARK: - Properties

    private var huds = Huds()

    private var downwards = false
    private var horizontal = true
    private let hudTypesLabel = UILabel()
    private var isPresenting = false

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGestures()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentAllTypes()
    }

    // MARK: - UI Setup

    private func setupUI() {
        setupHudTypesLabel()
    }

    private func setupHudTypesLabel() {
        hudTypesLabel.numberOfLines = 0
        hudTypesLabel.textAlignment = .center
        hudTypesLabel.font = .systemFont(ofSize: 16.0)
        hudTypesLabel.textColor = .clear // we use hudTypesLabel.attributedText
        view.addSubview(hudTypesLabel)

        hudTypesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hudTypesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hudTypesLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30
            ),
            hudTypesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            hudTypesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])

        highlightInHudTypesLabel()
    }

    private func setupGestures() {
        // Double tap gesture recognizer
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

    // MARK: - HUD Presentation

    private func presentAllTypes() {
        isPresenting = true
        presentNextIndicatorType()
    }

    private func presentCurrentIndicatorType() {
        // Present the current type
        view.dismissProgress()
        attachProgressHUD(indicatorStyle: huds.type)
        highlightInHudTypesLabel(highlightedType: huds.type)
    }

    private func presentNextIndicatorType() {
        presentCurrentIndicatorType()

        // Schedule the next presentation after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self, isPresenting else { return }
            huds.next(downwards)
            presentNextIndicatorType()
        }
    }

    // Create, configure and attach the progress HUD with the specified indicator style
    private func attachProgressHUD(indicatorStyle: NVActivityIndicatorType) {
        let iprogress = iProgressHUD()
        iprogress.delegate = self
        iprogress.iprogressStyle = horizontal ? .horizontal : .vertical
        iprogress.indicatorStyle = indicatorStyle
        iprogress.isShowModal = false
        iprogress.boxSize = 50

        iprogress.attachProgress(toView: view)
        view.showProgress()
    }

    // MARK: - UI Updates

    private func highlightInHudTypesLabel(highlightedType: NVActivityIndicatorType? = nil) {
        let attributedString = NSMutableAttributedString()

        for itype in NVActivityIndicatorType.allTypes {
            let typeString = "\n\(itype)"
            let attributes: [NSAttributedString.Key: Any] = [
                .font: itype == highlightedType
                    ? UIFont.boldSystemFont(ofSize: 16.0) : UIFont.systemFont(ofSize: 16.0),
                .foregroundColor: itype == highlightedType ? UIColor.blue : UIColor.gray,
            ]
            attributedString.append(NSAttributedString(string: typeString, attributes: attributes))
        }

        hudTypesLabel.attributedText = attributedString
    }

    // MARK: - Gesture Handlers

    @objc private func handleDoubleTapGesture() {
        performSegue(withIdentifier: "toViewController3", sender: self)
    }

    @objc private func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .up:
            downwards = false
            huds.prev()
        case .down:
            downwards = true
            huds.next()
        case .left, .right:
            horizontal.toggle()
        default:
            break
        }
        presentCurrentIndicatorType()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == "toViewController3" {
            isPresenting = false
            view.dismissProgress()
        }
    }
}

// MARK: - iProgressHUDDelegate

extension ViewController2: iProgressHUDDelegate {
    func onTouch(view: UIView) {
        print("VC2: HUD touched on \(type(of: view)) at \(Date())")
    }

    func onShow(view: UIView) {
        print("VC2: HUD shown on \(type(of: view)) at \(Date())")
    }

    func onDismiss(view: UIView) {
        print("VC2: HUD dismissed from \(type(of: view)) at \(Date())")
    }
}
