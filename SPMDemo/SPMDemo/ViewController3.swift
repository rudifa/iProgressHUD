//
//  ViewController3.swift
//  SPMDemo
//
//  Created by Rudolf Farkas on 09.10.2024.
//

import iProgressHUD
import UIKit

class ViewController3: UIViewController, iProgressHUDDelegete {
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

        //        presentAllTypes()
        presentAllTypesInGrid()
    }

    @objc func handleDoubleTapGesture() {
        print("vc3 double tap")
        performSegue(withIdentifier: "unwindToViewController1", sender: self)
    }

    // MARK: present all HUD types in a grid

    func presentAllTypesInGrid() {
        addBorderToFreeArea()
        createAndPlaceHUDs()
    }

    private func createAndPlaceHUDs() {
        for (index, itype) in NVActivityIndicatorType.allTypes.enumerated() {
            let position = calculateHUDPosition(for: index)
            let hudView = createHUDView(at: position, with: itype)
            view.addSubview(hudView)
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

    private func createHUDView(at position: CGPoint, with type: NVActivityIndicatorType) -> UIView {
        let hudView = UIView(
            frame: CGRect(origin: position, size: CGSize(width: boxSize, height: boxSize)))
        let iprogress = configureProgressHUD(for: type)
        iprogress.attachProgress(toView: hudView)
        hudView.showProgress()
        return hudView
    }

    private func configureProgressHUD(for type: NVActivityIndicatorType) -> iProgressHUD {
        let iprogress = iProgressHUD()
        iprogress.iprogressStyle = .vertical
        iprogress.indicatorStyle = type
        iprogress.isShowModal = false
        iprogress.boxSize = boxSize
        iprogress.boxColor = .lightGray
        iprogress.captionText = "\(type)"
        return iprogress
    }

    private var boxSize: CGFloat {
        let freeAreaWidth = freeAreaRect.width
        let freeAreaHeight = freeAreaRect.height
        let boxWidth = freeAreaWidth / CGFloat(hudsPerLine)
        let numLines = (NVActivityIndicatorType.allTypes.count + hudsPerLine - 1) / hudsPerLine
        let boxHeight = freeAreaHeight / CGFloat(numLines)
        return min(boxWidth, boxHeight)
    }

    // MARK: Utilites

    fileprivate func freeArea() -> CGRect {
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
        let borderView = UIView(frame: freeAreaRect)
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.red.cgColor
        view.addSubview(borderView)
    }
}
