import Foundation
import iProgressHUD
import UIKit

@propertyWrapper
struct UserDefaultsStored<T> {
    private let key: String
    private let defaultValue: T

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

class HUDTypeManager {
    static let shared = HUDTypeManager()

    @UserDefaultsStored(key: "currentHUDTypeIndex", defaultValue: 0)
    var currentIndex: Int

    private init() {}
}

// Usage:
// class ViewController3: UIViewController, iProgressHUDDelegete {
//     // ... other properties ...

//     @UserDefaultsStored(key: "currentHUDTypeIndex", defaultValue: 0)
//     private var currentIndex: Int

//     // ... rest of the class implementation ...
// }
