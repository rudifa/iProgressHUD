# iProgressHUD: develop a SPM package


# Base

> describe files and folders

# Working on local SPM package in SPMDemo


# Working on local Pod in iProgressHUDDemo

In the directory `~/GitHub/iOS/rudifa/HOT/iProgressHUD/iProgressHUDDemo`

1. modify the existing `./iProgressHUDDemo/Podfile

```
@@ -2,5 +2,6 @@ use_frameworks!
 platform :ios, '15.0'

 target 'iProgressHUDDemo' do
-    pod 'iProgressHUD', :git => 'https://github.com/epajot/iProgressHUD.git'
+    # pod 'iProgressHUD', :git => 'https://github.com/epajot/iProgressHUD.git'
+    pod 'iProgressHUD', :path => "/Users/rudifarkas/GitHub/iOS/rudifa/HOT/iProgressHUD"
 end
```

2. run `pod install`

```
iProgressHUDDemo % pod install                                                                                                                          [rename-delegate L|✚1]
Ignoring ffi-1.12.2 because its extensions are not built. Try: gem pristine ffi --version 1.12.2
Ignoring redcarpet-3.5.0 because its extensions are not built. Try: gem pristine redcarpet --version 3.5.0
Ignoring sassc-2.4.0 because its extensions are not built. Try: gem pristine sassc --version 2.4.0
Analyzing dependencies
Downloading dependencies
Installing iProgressHUD 1.2.2
Generating Pods project
Integrating client project
Pod installation complete! There is 1 dependency from the Podfile and 1 total pod installed.
```

3. in Xcode open `./iProgressHUDDemo.xcworkspace`, NOT `./ProgressHUDDemo.xcodeproj`

4. build and run the demo app for the local iPhone

