//
//  iProgressHUD.swift
//  iProgressHUD
//
//  Created by Saiful I. Wicaksana on 12/01/18.
//  Copyright © 2018 icaksama. All rights reserved.
//

import Foundation
import UIKit

/** List of iProgressHUD Styles */
public enum iProgressHUDStyles {
    case vertical
    case horizontal
}

open class iProgressHUD {
    private weak var view: UIView?

    /** Setting indicator style. Default is ballClipRotatePulse. */
    open var indicatorStyle: NVActivityIndicatorType = .ballClipRotatePulse
    /** Setting iprogress style in vertical or horizontal. Default is vertical. */
    open var iprogressStyle: iProgressHUDStyles = .vertical
    /** Get the indicator view. */
    open var indicatorView: NVActivityIndicatorView!
    /** Get the modal view. You can set image on modal view. */
    public let modalView: UIImageView = .init()
    /** Get the box view. You can set image on box view. */
    public let boxView: UIImageView!
    /** Get the caption view. */
    public let captionView: UILabel!
    /** Setting the indicator size in percent of box view. Default is 60%. */
    open var indicatorSize: CGFloat = 60
    /** Setting the alpha of modal view. Default is 0.7 */
    open var alphaModal: CGFloat = 0.7
    /** Setting the alpha of box view. Default is 0.7 */
    open var alphaBox: CGFloat = 0.7
    /** Setting box size in percent of width view. Default is 50%. */
    open var boxSize: CGFloat = 50
    /** Setting the corner radius of box view. Default is 12. */
    open var boxCorner: CGFloat = 12
    /** Setting the caption distance with indicator view. Default is 0. */
    open var captionDistance: CGFloat = 0
    /** Show or hide the caption view. Default is true. */
    open var isShowCaption: Bool = true
    /** Show or hide the modal view. Default is true. */
    open var isShowModal: Bool = true
    /** Show or hide the box view. Default is true. */
    open var isShowBox: Bool = true
    /** Give blur effect in modal view. Default is false. */
    open var isBlurModal: Bool = false
    /** Give blur effect in box view. Default is false. */
    open var isBlurBox: Bool = false
    /** Make the progress touchable. Default is false. */
    open var isTouchDismiss: Bool = false
    /** Change the modal view color. Default is white. */
    open var modalColor: UIColor = .clear
    /** Change the box view color. Default is black. */
    open var boxColor: UIColor = .clear
    /** Change the text color of caption. Default is white. */
    open var captionColor: UIColor = .white
    /** Change the indicator view color. Default is white. */
    open var indicatorColor: UIColor = .white
    /** Change the font size of caption. Default is 20. */
    open var captionSize: CGFloat = 20
    /** Setting the delegate. */
    open var delegate: iProgressHUDDelegate?

    public init() {
        indicatorView = NVActivityIndicatorView(frame: .zero)
        boxView = UIImageView(frame: .zero)
        captionView = UILabel(frame: .zero)
    }

    public init(style: NVActivityIndicatorType) {
        indicatorView = NVActivityIndicatorView(frame: .zero)
        boxView = UIImageView(frame: .zero)
        captionView = UILabel(frame: .zero)
        indicatorView.type = style
    }

    /** get sharedInstance class of iProgressHUD */
    public static func sharedInstance() -> iProgressHUD {
        let iPHUD = iProgressHUD()
        return iPHUD
    }

    /** Attach the iProgressHUD in views */
    open func attachProgress(toViews: UIView...) {
        for view in toViews {
            let reinit = copy()
            reinit.view = view
            reinit.setupProgress(view: view)
            view.iprogressHud = reinit
        }
    }

    /** Attach the iProgressHUD in array views */
    open func attachProgress(toViews: [UIView]) {
        for view in toViews {
            let reinit = copy()
            reinit.view = view
            reinit.setupProgress(view: view)
            view.iprogressHud = reinit
        }
    }

    /** Attach the iProgressHUD in single view */
    open func attachProgress(toView: UIView) {
        let reinit = copy()
        reinit.view = toView
        reinit.setupProgress(view: toView)
        toView.iprogressHud = reinit
    }

    /** Check the progress is show or not. */
    open func isShowing() -> Bool {
        indicatorView.isAnimating
    }

    /** Show iProgressHUD */
    open func show() {
        modalView.isHidden = false
        boxView.isHidden = false
        indicatorView.startAnimating()
        if delegate != nil {
            delegate?.onShow!(view: view!)
        }
    }

    /** Dismiss iProgressHUD */
    open func dismiss() {
        modalView.isHidden = true
        boxView.isHidden = true
        indicatorView.stopAnimating()
        if delegate != nil {
            delegate?.onDismiss!(view: view!)
        }
    }

    private func setupProgress(view: UIView) {
        boxSetting(view: view)
        indicatorSetting()
        captionSetting()
        modalSetting(view: view)

        let boxCenter = CGPoint(x: boxView.bounds.size.width / 2, y: boxView.bounds.size.height / 2)

        progressStyleSetting(boxCenter: boxCenter)

        if !isShowBox {
            boxView.backgroundColor = .clear
            if isBlurBox {
                boxView.subviews[0].removeFromSuperview()
            }
        }
        if isBlurBox {
            iProgressHUDUtilities.blurEffect(view: boxView, corner: boxCorner)
            boxView.alpha = 1
            boxView.backgroundColor = .clear
        }
        if isBlurModal {
            iProgressHUDUtilities.blurEffect(view: modalView, corner: 0)
            modalView.alpha = 1
            modalView.backgroundColor = .clear
        }
        if !isShowModal {
            modalView.backgroundColor = .clear
            if isBlurModal {
                modalView.subviews[0].removeFromSuperview()
            }
        }
        boxView.addSubview(indicatorView)
        if isShowCaption {
            boxView.addSubview(captionView)
        } else {
            indicatorView.center = boxCenter
        }
        view.addSubview(modalView)
        view.addSubview(boxView)
        if let lastViews = view.subviews.last {
            modalView.bringSubviewToFront(lastViews)
        } else {
            modalView.bringSubviewToFront(view)
        }
        boxView.bringSubviewToFront(modalView)
        modalView.isHidden = true
        boxView.isHidden = true

        if isTouchDismiss {
            let tap = UITapGestureRecognizer(target: self, action: #selector(touched))
            modalView.addGestureRecognizer(tap)
        }
    }

    @objc func touched() {
        dismiss()
        if delegate != nil {
            delegate?.onTouch!(view: view!)
        }
    }

    private func modalSetting(view: UIView) {
        modalView.frame = view.bounds
        modalView.backgroundColor = modalColor
        modalView.alpha = alphaModal
        modalView.isUserInteractionEnabled = true
    }

    private func indicatorSetting() {
        indicatorView.type = indicatorStyle
        indicatorView.color = indicatorColor
        indicatorView.autoresizingMask = [
            .flexibleLeftMargin,
            .flexibleRightMargin,
            .flexibleBottomMargin,
            .flexibleTopMargin,
        ]
        let indSize = iProgressHUDUtilities.getHeightPercent(view: boxView, percent: indicatorSize)
        indicatorView.frame.size = CGSize(width: indSize, height: indSize)
    }

    private func boxSetting(view: UIView) {
        let boxCenter = CGPoint(x: view.bounds.size.width / 2, y: view.bounds.size.height / 2)
        boxView.backgroundColor = boxColor
        boxView.layer.cornerRadius = boxCorner
        boxView.alpha = alphaBox
        var boxWidth: CGFloat = 0
        var boxHeight: CGFloat = 0
        if iProgressHUDUtilities.getWidthPercent(view: view, percent: 100) < iProgressHUDUtilities.getHeightPercent(view: view, percent: 100) {
            boxWidth = iProgressHUDUtilities.getWidthPercent(view: view, percent: boxSize)
            if iprogressStyle == iProgressHUDStyles.vertical {
                boxHeight = iProgressHUDUtilities.getWidthPercent(view: view, percent: boxSize)
            } else if iprogressStyle == iProgressHUDStyles.horizontal {
                boxHeight = iProgressHUDUtilities.getWidthPercent(view: view, percent: boxSize / 3)
            }
        } else {
            boxWidth = iProgressHUDUtilities.getHeightPercent(view: view, percent: boxSize)
            if iprogressStyle == iProgressHUDStyles.vertical {
                boxHeight = iProgressHUDUtilities.getHeightPercent(view: view, percent: boxSize)
            } else if iprogressStyle == iProgressHUDStyles.horizontal {
                boxHeight = iProgressHUDUtilities.getHeightPercent(view: view, percent: boxSize / 3)
            }
        }
        boxView.frame = CGRect(x: 0, y: 0, width: boxWidth, height: boxHeight)
        boxView.center = boxCenter
    }

    private func captionSetting() {
        captionView.text = "loading..."
        captionView.font = UIFont.boldSystemFont(ofSize: captionSize)
        captionView.textColor = captionColor
        captionView.textAlignment = .center
        captionView.adjustsFontSizeToFitWidth = true
        if iprogressStyle == iProgressHUDStyles.vertical {
            captionView.setWidth(width: boxView.bounds.width - 5)
            let preferredSize = iProgressHUDUtilities.getSizeUILabel(label: captionView)
            captionView.setHeight(height: preferredSize.height)
        } else if iprogressStyle == iProgressHUDStyles.horizontal {
            captionView.setWidth(width: boxView.bounds.width - (indicatorView.frame.width * 2))
            let preferredSize = iProgressHUDUtilities.getSizeUILabel(label: captionView)
            captionView.setHeight(height: preferredSize.height)
        }
    }

    func progressStyleSetting(boxCenter: CGPoint) {
        if iprogressStyle == iProgressHUDStyles.vertical {
            indicatorView.center.x = boxCenter.x
            captionView.center.x = boxCenter.x
            indicatorView.center.y = boxCenter.y
            let indicatorY = CGPoint(x: boxCenter.x, y: (boxCenter.y - (indicatorView.frame.size.height / 2)) - ((captionView.frame.size.height + captionDistance) / 2))
            indicatorView.setY(y: indicatorY.y)
            captionView.setY(y: indicatorView.frame.maxY + captionDistance)
        } else if iprogressStyle == iProgressHUDStyles.horizontal {
            indicatorView.center.y = boxCenter.y
            captionView.center.y = boxCenter.y
            indicatorView.center.x = boxCenter.x
            let indicatorX = CGPoint(x: (boxCenter.x - (indicatorView.frame.size.width / 2)) - ((captionView.frame.size.width + captionDistance) / 2), y: boxCenter.y)
            indicatorView.setX(x: indicatorX.x)
            captionView.setX(x: indicatorView.frame.maxX + captionDistance)
        }
    }
}
