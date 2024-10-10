//
//  ViewController3.swift
//  SPMDemo
//
//  Created by Rudolf Farkas on 09.10.2024.
//

import iProgressHUD
import UIKit

class ViewController3: UIViewController {
    let hudTypesLabel = UILabel()

    // Number of HUDs per grid line
    private let hudsPerLine = 4

    // Get the free area rectangle
    private var freeAreaRect: CGRect {
        freeArea()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add double tap gesture recognizer
        let doubleTapGesture = UITapGestureRecognizer(
            target: self, action: #selector(handleDoubleTapGesture)
        )
        doubleTapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapGesture)
    }

    override func viewDidAppear(_: Bool) {
        super.viewDidAppear(true)

        presentAllTypesInGrid()
    }

    // MARK: Navigation

    @objc func handleDoubleTapGesture() {
        print("vc3 double tap")
        dismissAllHUDs()
        performSegue(withIdentifier: "unwindToViewController1", sender: self)
    }

    private func dismissAllHUDs() {
        for subview in view.subviews {
            subview.dismissProgress()
        }
        // Also dismiss progress on the main view itself
        view.dismissProgress()
    }

    // MARK: present all HUD types in a grid

    func presentAllTypesInGrid() {
        // addBorderToFreeArea() // for debug
        attachAndPlaceHUDs()
    }

    private func attachAndPlaceHUDs() {
        for (index, itype) in NVActivityIndicatorType.allTypes.enumerated() {
            let position = calculateHUDPosition(for: index)
            attachHUDView(at: position, with: itype)
        }
    }

    private func calculateHUDPosition(for index: Int) -> CGPoint {
        let xIndex = CGFloat(index % hudsPerLine)
        let yIndex = CGFloat(index / hudsPerLine)
        let xSpacing = max((freeAreaRect.width / CGFloat(hudsPerLine)) - boxSize, 0)
        let ySpacing = max(
            (freeAreaRect.height
                / CGFloat((NVActivityIndicatorType.allTypes.count + hudsPerLine - 1) / hudsPerLine))
                - boxSize, 0
        )

        let originX = freeAreaRect.origin.x + xIndex * (boxSize + xSpacing) + xSpacing / 2
        let originY = freeAreaRect.origin.y + yIndex * (boxSize + ySpacing) + ySpacing / 2

        return CGPoint(x: originX, y: originY)
    }

    private func attachHUDView(at position: CGPoint, with type: NVActivityIndicatorType) {
        let hudView = UIView(
            frame: CGRect(origin: position, size: CGSize(width: boxSize, height: boxSize)))
        createConfigureAndAttach(for: type, to: hudView)
        view.addSubview(hudView)
    }

    // Create, configure and attach the progress HUD with the specified indicator style to the view
    private func createConfigureAndAttach(for type: NVActivityIndicatorType, to view: UIView) {
        let iprogress = iProgressHUD()
        iprogress.iprogressStyle = .vertical
        iprogress.indicatorStyle = type
        iprogress.isShowModal = false
        iprogress.boxSize = boxSize
        iprogress.boxColor = .lightGray
        iprogress.captionText = "\(type)"
        iprogress.delegate = self

        iprogress.attachProgress(toView: view)
        view.showProgress()
    }

    private var boxSize: CGFloat {
        let freeAreaWidth = freeAreaRect.width
        let freeAreaHeight = freeAreaRect.height
        let boxWidth = freeAreaWidth / CGFloat(hudsPerLine)
        let numLines = (NVActivityIndicatorType.allTypes.count + hudsPerLine - 1) / hudsPerLine
        let boxHeight = freeAreaHeight / CGFloat(numLines)
        return min(boxWidth, boxHeight)
    }

    // MARK: Utilites of general use

    private func freeArea() -> CGRect {
        let safeAreaInsets = view.safeAreaInsets
        let safeAreaVerticalExtent = view.bounds.height - safeAreaInsets.top - safeAreaInsets.bottom
        let safeAreaHorizontalExtent =
            view.bounds.width - safeAreaInsets.left - safeAreaInsets.right

        let safeAreaOriginY = safeAreaInsets.top
        let safeAreaOriginX = safeAreaInsets.left

        return CGRect(
            x: safeAreaOriginX, y: safeAreaOriginY, width: safeAreaHorizontalExtent,
            height: safeAreaVerticalExtent
        )
    }

    private func addBorderToFreeArea() {
        let borderView = UIView(frame: freeArea())
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.red.cgColor
        view.addSubview(borderView)
    }
}

// MARK: - iProgressHUDDelegate

extension ViewController3: iProgressHUDDelegate {
    func onTouch(view: UIView) {
        print("VC3: HUD touched on \(type(of: view)) at \(Date())")
    }

    func onShow(view: UIView) {
        print("VC3: HUD shown on \(type(of: view)) at \(Date())")
    }

    func onDismiss(view: UIView) {
        print("VC3: HUD dismissed from \(type(of: view)) at \(Date())")
    }
}
