# Add a SPM package to this project

- by [@rudifa](https://github.com/rudifa)

## Objectives

- keep the existing `iProgressHUD` source code, up to now exposed as a **Cocoa Pod** and expose it also as a **Swift package**.

- add a demo for the new package

## WIP

The new tree of the project looks like this, the added items being the file `Package.swift` and the directory `SPMDemo`.

```
iProgressHUD % tree -L 2                                                                                                [develop-package-3 L|…1]
.
├── SPMDemo
│   ├── SPMDemo
│   └── SPMDemo.xcodeproj
├── iProgressHUD
│   ├── iProgressHUD
│   └── iProgressHUD.xcodeproj
├── iProgressHUDDemo
│   ├── Pods
│   ├── build
│   ├── iProgressHUDDemo
│   ├── iProgressHUDDemo.xcodeproj
│   ├── iProgressHUDDemo.xcworkspace
│   ├── Podfile
│   ├── Podfile.lock
│   └── USING_PODS:_OPEN_IN_.xcworkspace!
├── LICENSE
├── Package.swift
├── Preview.png
├── README-SPM.md
├── README.md
├── iProgressHUD.podspec
└── iProgressHUDLogo.png
```

In the SPM package, the file `Package.swift` plays a role similar to that of the file `iProgressHUD.podspec`: they both specify the source files that belong to the package resp. to the pod, and define other configuration parameters.
