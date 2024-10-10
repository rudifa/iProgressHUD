

Rudolf Farkas
would it be difficult to attach a iProgressHUD to a SwiftUI view?


Attaching an iProgressHUD to a SwiftUI view would require some additional steps, as iProgressHUD is designed for UIKit. However, it's certainly possible to use it in SwiftUI by wrapping it in a UIViewRepresentable. Here's a general approach you could take:

1. Create a UIViewRepresentable wrapper for iProgressHUD:

```swift
struct IProgressHUDView: UIViewRepresentable {
    var indicatorStyle: NVActivityIndicatorType
    var isHorizontal: Bool

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let iprogress = iProgressHUD()
        iprogress.iprogressStyle = isHorizontal ? .horizontal : .vertical
        iprogress.indicatorStyle = indicatorStyle
        iprogress.isShowModal = false
        iprogress.boxSize = 50
        iprogress.captionText = "\(indicatorStyle)"
        iprogress.boxColor = .lightGray
        iprogress.indicatorColor = .white
        iprogress.modalColor = .black.withAlphaComponent(0.3)

        iprogress.attachProgress(toView: view)
        view.showProgress()

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // Update the view if needed
    }
}
```

2. Use this wrapper in your SwiftUI view:

```swift
struct ContentView: View {
    @State private var indicatorStyle: NVActivityIndicatorType = .ballSpinFadeLoader
    @State private var isHorizontal = false

    var body: some View {
        VStack {
            IProgressHUDView(indicatorStyle: indicatorStyle, isHorizontal: isHorizontal)
                .frame(width: 100, height: 100)

            Button("Change Style") {
                indicatorStyle = NVActivityIndicatorType.allTypes.randomElement() ?? .ballSpinFadeLoader
            }

            Toggle("Horizontal", isOn: $isHorizontal)
        }
    }
}
```

This approach allows you to use iProgressHUD in SwiftUI, but keep in mind that you might lose some of the direct control and flexibility you have in UIKit. You'd need to expose any properties or methods you want to control from SwiftUI through the UIViewRepresentable wrapper.

Also, remember that this is just a basic implementation. Depending on your specific needs, you might need to add more functionality to the wrapper, such as methods to show/hide the HUD or to change its properties dynamically.


Rudolf Farkas
could I add the wrapper to this SPM package pehaps exposing func  getSwiftUIProgressHudWrapped  and use it in a SwiftUI project as you showed?


Absolutely! That's an excellent idea to extend the functionality of your package to support SwiftUI. Here's how you could implement this:

1. First, create a new Swift file in your package, let's call it `SwiftUIProgressHUD.swift`.

2. In this file, implement the UIViewRepresentable wrapper and the function to get the wrapped view:

```swift
import SwiftUI
import iProgressHUD

public struct SwiftUIProgressHUD: UIViewRepresentable {
    var indicatorStyle: NVActivityIndicatorType
    var isHorizontal: Bool
    var boxSize: CGFloat
    var captionText: String
    var boxColor: UIColor
    var indicatorColor: UIColor
    var modalColor: UIColor

    public func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let iprogress = iProgressHUD()
        iprogress.iprogressStyle = isHorizontal ? .horizontal : .vertical
        iprogress.indicatorStyle = indicatorStyle
        iprogress.isShowModal = false
        iprogress.boxSize = boxSize
        iprogress.captionText = captionText
        iprogress.boxColor = boxColor
        iprogress.indicatorColor = indicatorColor
        iprogress.modalColor = modalColor

        iprogress.attachProgress(toView: view)
        view.showProgress()

        return view
    }

    public func updateUIView(_ uiView: UIView, context: Context) {
        // Update the view if needed
    }
}

public extension iProgressHUD {
    static func getSwiftUIProgressHudWrapped(
        indicatorStyle: NVActivityIndicatorType = .ballSpinFadeLoader,
        isHorizontal: Bool = false,
        boxSize: CGFloat = 50,
        captionText: String = "",
        boxColor: UIColor = .lightGray,
        indicatorColor: UIColor = .white,
        modalColor: UIColor = UIColor.black.withAlphaComponent(0.3)
    ) -> SwiftUIProgressHUD {
        SwiftUIProgressHUD(
            indicatorStyle: indicatorStyle,
            isHorizontal: isHorizontal,
            boxSize: boxSize,
            captionText: captionText,
            boxColor: boxColor,
            indicatorColor: indicatorColor,
            modalColor: modalColor
        )
    }
}
```

3. Make sure to expose this new file in your package's public interface.

4. Now, users of your package can use this in their SwiftUI projects like this:

```swift
import SwiftUI
import iProgressHUD

struct ContentView: View {
    var body: some View {
        VStack {
            iProgressHUD.getSwiftUIProgressHudWrapped(
                indicatorStyle: .ballSpinFadeLoader,
                isHorizontal: false,
                boxSize: 50,
                captionText: "Loading...",
                boxColor: .lightGray,
                indicatorColor: .white,
                modalColor: UIColor.black.withAlphaComponent(0.3)
            )
            .frame(width: 100, height: 100)

            Text("Other SwiftUI content")
        }
    }
}
```

This approach allows users of your package to easily integrate iProgressHUD into their SwiftUI projects while maintaining the flexibility to customize various aspects of the HUD.

Remember to update your package's documentation to include information about this new SwiftUI support and how to use it.
