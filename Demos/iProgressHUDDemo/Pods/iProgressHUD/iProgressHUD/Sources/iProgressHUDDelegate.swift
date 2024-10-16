//
//  iProgressHUDDelegate.swift
//  iProgressHUD
//
//  Created by Saiful I. Wicaksana on 12/01/18.
//  Copyright © 2018 icaksama. All rights reserved.
//

import UIKit

@objc public protocol iProgressHUDDelegate {
    @objc optional func onTouch(view: UIView)
    @objc optional func onShow(view: UIView)
    @objc optional func onDismiss(view: UIView)
}
