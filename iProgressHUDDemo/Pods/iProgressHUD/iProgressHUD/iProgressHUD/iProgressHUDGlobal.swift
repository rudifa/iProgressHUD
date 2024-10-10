//
//  iProgressHUDGlobal.swift
//  iProgressHUD
//
//  Created by Saiful I. Wicaksana on 12/01/18.
//  Copyright © 2018 icaksama. All rights reserved.
//

import Foundation
import ObjectiveC
import UIKit

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.connectedScenes
        .filter { $0.activationState == .foregroundActive }
        .compactMap { $0 as? UIWindowScene }
        .first?.windows
        .filter(\.isKeyWindow)
        .first?.rootViewController) -> UIViewController?
    {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

public extension UIView {
    private enum AssociatedKeys {
        static var iprogressHud: Void?
    }

    /** Set x Position */
    internal func setX(x: CGFloat) {
        var frame: CGRect = frame
        frame.origin.x = x
        self.frame = frame
    }

    /** Set y Position */
    internal func setY(y: CGFloat) {
        var frame: CGRect = frame
        frame.origin.y = y
        self.frame = frame
    }

    /** Set z Position */
    internal func setZ(z: CGFloat) {
        layer.zPosition = z
    }

    /** Set Width */
    internal func setWidth(width: CGFloat) {
        var frame: CGRect = frame
        frame.size.width = width
        self.frame = frame
    }

    /** Set Height */
    internal func setHeight(height: CGFloat) {
        var frame: CGRect = frame
        frame.size.height = height
        self.frame = frame
    }

    /** Get class of iProgressHUD. Make sure to attach progress first in this view. */
    internal var iprogressHud: iProgressHUD? {
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.iprogressHud) as? iProgressHUD
        }
        set {
            if let newValue {
                // Assurez-vous d'utiliser correctement la clé statique comme pointeur
                objc_setAssociatedObject(self, &AssociatedKeys.iprogressHud, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                // Si newValue est nil, vous devez retirer l'objet associé
                objc_setAssociatedObject(self, &AssociatedKeys.iprogressHud, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    /** Show the iProgressHUD directly from this view. */
    func showProgress() {
        if iprogressHud == nil {
            print("Failed! iProgressHUD never attached in this view.")
            return
        }
        iprogressHud?.show()
    }

    /** Stop the iProgressHUD directly from this view. */
    func dismissProgress() {
        if iprogressHud == nil {
            print("Failed! iProgressHUD never attached in this view.")
            return
        }
        iprogressHud?.dismiss()
    }

    /** Update the indicator style of iProgressHUD directly from this view. */
    func updateIndicator(style: NVActivityIndicatorType) {
        if iprogressHud == nil {
            print("Failed! iProgressHUD never attached in this view.")
            return
        }
        iprogressHud?.indicatorStyle = style
        iprogressHud?.indicatorView.type = style
        iprogressHud?.indicatorView.setUpAnimation()
    }

    /** Update the caption of iProgressHUD directly from this view. */
    func updateCaption(text: String) {
        if iprogressHud == nil {
            print("Failed! iProgressHUD never attached in this view.")
            return
        }
        iprogressHud?.captionView.text = text
        iprogressHud?.captionView.sizeToFit()
        let boxCenter = CGPoint(x: (iprogressHud?.boxView.frame.size.width)! / 2, y: (iprogressHud?.boxView.frame.size.height)! / 2)
        iprogressHud?.progressStyleSetting(boxCenter: boxCenter)
    }

    /** Update colors of iProgressHUD. Set nil if want not to change. */
    func updateColors(modalColor: UIColor?, boxColor: UIColor?, indicatorColor: UIColor?, captionColor: UIColor?) {
        if iprogressHud == nil {
            print("Failed! iProgressHUD never attached in this view.")
            return
        }
        if modalColor != nil {
            iprogressHud?.modalColor = modalColor!
            iprogressHud?.modalView.backgroundColor = modalColor
        }

        if boxColor != nil {
            iprogressHud?.boxColor = boxColor!
            iprogressHud?.boxView.backgroundColor = boxColor
        }

        if indicatorColor != nil {
            iprogressHud?.indicatorColor = indicatorColor!
            iprogressHud?.indicatorView.color = indicatorColor!
            iprogressHud?.indicatorView.setUpAnimation()
        }

        if captionColor != nil {
            iprogressHud?.captionColor = captionColor!
            iprogressHud?.captionView.textColor = captionColor
        }
    }
}

extension iProgressHUD {
    func copy() -> iProgressHUD {
        let reinit = iProgressHUD()
        reinit.indicatorStyle = indicatorStyle
        reinit.iprogressStyle = iprogressStyle
        reinit.indicatorSize = indicatorSize
        reinit.alphaModal = alphaModal
        reinit.boxSize = boxSize
        reinit.boxCorner = boxCorner
        reinit.captionDistance = captionDistance
        reinit.isShowCaption = isShowCaption
        reinit.isShowModal = isShowModal
        reinit.isShowBox = isShowBox
        reinit.isBlurBox = isBlurModal
        reinit.isBlurBox = isBlurBox
        reinit.isTouchDismiss = isTouchDismiss
        reinit.modalColor = modalColor
        reinit.boxColor = boxColor
        reinit.captionColor = captionColor
        reinit.indicatorColor = indicatorColor
        reinit.captionSize = captionSize
        reinit.delegate = delegate
        return reinit
    }
}
