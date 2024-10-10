import UIKit

//
//  ViewController2.swift
//  SPMDemo
//
//  Created by Rudolf Farkas on 08.10.2024.
//
import iProgressHUD

class ViewController2: UIViewController {
    // MARK: - Properties

    private let hudTypesLabel = UILabel()
    private var currentIndex: Int {
        get { UserDefaults.standard.integer(forKey: "currentHUDTypeIndex") }
        set { UserDefaults.standard.set(newValue, forKey: "currentHUDTypeIndex") }
    }

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
        hudTypesLabel.textColor = .lightGray
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

        updateHudTypesLabel()
    }

    private func setupGestures() {
        let doubleTapGesture = UITapGestureRecognizer(
            target: self, action: #selector(handleDoubleTapGesture)
        )
        doubleTapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapGesture)
    }

    // MARK: - HUD Presentation

    private func presentAllTypes() {
        presentNextIndicatorType(index: currentIndex)
    }

    private func presentNextIndicatorType(index: Int) {
        let count = NVActivityIndicatorType.allTypes.count
        currentIndex = index % count
        let itype = NVActivityIndicatorType.allTypes[currentIndex]

        setupProgressHUD(indicatorStyle: itype)
        updateHudTypesLabel(highlightedType: itype)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.view.dismissProgress()
            self?.presentNextIndicatorType(index: index + 1)
        }
    }

    private func setupProgressHUD(indicatorStyle: NVActivityIndicatorType) {
        let iprogress = iProgressHUD()
        iprogress.delegete = self
        iprogress.iprogressStyle = .horizontal
        iprogress.indicatorStyle = indicatorStyle
        iprogress.isShowModal = false
        iprogress.boxSize = 50

        iprogress.attachProgress(toView: view)
        view.showProgress()
    }

    // MARK: - UI Updates

    private func updateHudTypesLabel(highlightedType: NVActivityIndicatorType? = nil) {
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

    // MARK: - Navigation

    @objc private func handleDoubleTapGesture() {
        performSegue(withIdentifier: "toViewController3", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == "toViewController3" {
            view.dismissProgress()
        }
    }
}

// MARK: - iProgressHUDDelegete

extension ViewController2: iProgressHUDDelegete {
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
