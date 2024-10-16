//
//  Huds.swift
//  SPMDemo
//
//  Created by Rudolf Farkas on 10.10.2024.
//

import Foundation
import iProgressHUD

// The Huds struct manages the current HUD type index and provides methods to navigate through all available NVActivityIndicatorType types.
// It stores the current index in UserDefaults to persist the state across app launches.
struct Huds {
    // Key for storing the current HUD type index in UserDefaults
    private static let userDefaultsKey = "currentHUDTypeIndex"

    // Array of all available NVActivityIndicatorType types
    private let types: [NVActivityIndicatorType] = NVActivityIndicatorType.allTypes

    // Computed property for getting and setting the current index in UserDefaults
    private var currentIndex: Int {
        get { UserDefaults.standard.integer(forKey: Self.userDefaultsKey) }
        set { UserDefaults.standard.set(newValue, forKey: Self.userDefaultsKey) }
    }

    // Public property to get and set the current index
    var index: Int {
        get { currentIndex }
        set { currentIndex = newValue % types.count }
    }

    // Public property to get and set the current NVActivityIndicatorType based on the current index
    var type: NVActivityIndicatorType {
        get { types[currentIndex] }
        set {
            if let newIndex = types.firstIndex(of: newValue) {
                currentIndex = newIndex
            }
        }
    }

    // Initializer to ensure the current index is within the bounds of the types array
    init() {
        if currentIndex >= types.count {
            currentIndex = 0
        }
    }

    // Method to move to the next or previous HUD type
    mutating func next(_ next: Bool = true) {
        if next {
            // Move to the next HUD type
            currentIndex = (currentIndex + 1) % types.count
        } else {
            // Move to the previous HUD type
            prev()
        }
    }

    // Method to move to the previous HUD type
    mutating func prev() {
        currentIndex = (currentIndex - 1 + types.count) % types.count
    }
}
