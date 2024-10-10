import UIKit

//
//  ViewController2.swift
//  SPMDemo
//
//  Created by Rudolf Farkas on 08.10.2024.
//
import iProgressHUD

struct Huds {
    private static let userDefaultsKey = "currentHUDTypeIndex"
    private let types: [NVActivityIndicatorType] = NVActivityIndicatorType.allTypes

    private var currentIndex: Int {
        get { UserDefaults.standard.integer(forKey: Self.userDefaultsKey) }
        set { UserDefaults.standard.set(newValue, forKey: Self.userDefaultsKey) }
    }

    var index: Int { currentIndex }
    var type: NVActivityIndicatorType { types[currentIndex] }

    init() {
        if currentIndex >= types.count {
            currentIndex = 0
        }
    }

    mutating func next(_ next: Bool = true) {
        if next {
            currentIndex = (currentIndex + 1) % types.count
        } else {
            prev()
        }
    }

    mutating func prev() {
        currentIndex = (currentIndex - 1 + types.count) % types.count
    }
}

class ViewController2: UIViewController {
    // MARK: - Properties

    private var huds = Huds()

    private var downwards = false
    private var horizontal = true
    private let hudTypesLabel = UILabel()

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
        presentNextIndicatorType()
    }

    private func presentCurrentIndicatorType() {
        // Present the current type
        view.dismissProgress()
        setupProgressHUD(indicatorStyle: huds.type)
        highlightInHudTypesLabel(highlightedType: huds.type)
    }

    private func presentNextIndicatorType() {
        presentCurrentIndicatorType()

        // Schedule the next presentation after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.view.dismissProgress()
            self?.huds.next(self?.downwards ?? true)
            self?.presentNextIndicatorType()
        }
    }

    private func setupProgressHUD(indicatorStyle: NVActivityIndicatorType) {
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
            view.dismissProgress()
        }
    }
}

// MARK: - iProgressHUDDelegate

extension ViewController2: iProgressHUDDelegate {
    func onShow(view _: UIView) {
        //        print("HUD shown on \(view)")
    }

    func onDismiss(view _: UIView) {
        //        print("HUD dismissed from \(view)")
    }

    func onTouch(view _: UIView) {
        //        print("HUD touched on \(view)")
    }
}
