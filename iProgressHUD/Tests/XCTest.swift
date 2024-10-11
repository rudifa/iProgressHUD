import XCTest

@testable import iProgressHUD

final class iProgressHUDTests: XCTestCase {
    static var allTests = [
        ("testExample", testExample),
    ]

    func testExample() {
        // This is an example of a functional test case.
        XCTAssertEqual(iProgressHUD().indicatorStyle, .ballClipRotatePulse)
    }

    func test_iProgressHUD_default() {
        let iprogress = iProgressHUD()

        // Test basic properties
        XCTAssertEqual(iprogress.indicatorStyle, .ballClipRotatePulse)
        XCTAssertEqual(iprogress.iprogressStyle, .vertical)
        XCTAssertEqual(iprogress.indicatorSize, 60)
        XCTAssertEqual(iprogress.alphaModal, 0.7)
        XCTAssertEqual(iprogress.alphaBox, 0.7)
        XCTAssertEqual(iprogress.boxSize, 50)
        XCTAssertEqual(iprogress.boxCorner, 12)
        XCTAssertEqual(iprogress.captionDistance, 0)
        XCTAssertTrue(iprogress.isShowCaption)
        XCTAssertTrue(iprogress.isShowModal)
        XCTAssertTrue(iprogress.isShowBox)
        XCTAssertFalse(iprogress.isBlurModal)
        XCTAssertFalse(iprogress.isBlurBox)
        XCTAssertFalse(iprogress.isTouchDismiss)
        XCTAssertEqual(iprogress.modalColor, .clear)
        XCTAssertEqual(iprogress.boxColor, .clear)
        XCTAssertEqual(iprogress.captionColor, .white)
        XCTAssertEqual(iprogress.indicatorColor, .white)
        XCTAssertEqual(iprogress.captionSize, 20)

        // Test that views are initialized
        XCTAssertNotNil(iprogress.indicatorView)
        XCTAssertNotNil(iprogress.modalView)
        XCTAssertNotNil(iprogress.boxView)
        XCTAssertNotNil(iprogress.captionView)

        // Test that delegate is nil by default
        XCTAssertNil(iprogress.delegate)

        // Test that the progress is not showing by default
        XCTAssertFalse(iprogress.isShowing())

        // Test the added property
        XCTAssertEqual(iprogress.captionText, "loading...")
    }

    func test_iProgressHUD_modifyProperties() {
        let iprogress = iProgressHUD()

        // Modify and test each property
        iprogress.indicatorStyle = .ballPulse
        XCTAssertEqual(iprogress.indicatorStyle, .ballPulse)

        iprogress.iprogressStyle = .horizontal
        XCTAssertEqual(iprogress.iprogressStyle, .horizontal)

        iprogress.indicatorSize = 80
        XCTAssertEqual(iprogress.indicatorSize, 80)

        iprogress.alphaModal = 0.5
        XCTAssertEqual(iprogress.alphaModal, 0.5)

        iprogress.alphaBox = 0.6
        XCTAssertEqual(iprogress.alphaBox, 0.6)

        iprogress.boxSize = 60
        XCTAssertEqual(iprogress.boxSize, 60)

        iprogress.boxCorner = 15
        XCTAssertEqual(iprogress.boxCorner, 15)

        iprogress.captionDistance = 10
        XCTAssertEqual(iprogress.captionDistance, 10)

        iprogress.isShowCaption = false
        XCTAssertFalse(iprogress.isShowCaption)

        iprogress.isShowModal = false
        XCTAssertFalse(iprogress.isShowModal)

        iprogress.isShowBox = false
        XCTAssertFalse(iprogress.isShowBox)

        iprogress.isBlurModal = true
        XCTAssertTrue(iprogress.isBlurModal)

        iprogress.isBlurBox = true
        XCTAssertTrue(iprogress.isBlurBox)

        iprogress.isTouchDismiss = true
        XCTAssertTrue(iprogress.isTouchDismiss)

        iprogress.modalColor = .red
        XCTAssertEqual(iprogress.modalColor, .red)

        iprogress.boxColor = .blue
        XCTAssertEqual(iprogress.boxColor, .blue)

        iprogress.captionColor = .green
        XCTAssertEqual(iprogress.captionColor, .green)

        iprogress.indicatorColor = .yellow
        XCTAssertEqual(iprogress.indicatorColor, .yellow)

        iprogress.captionSize = 25
        XCTAssertEqual(iprogress.captionSize, 25)

        // Test setting delegate
        let mockDelegate = MockProgressHUDDelegate()
        iprogress.delegate = mockDelegate
        XCTAssertNotNil(iprogress.delegate)

        // Test setting caption text
        iprogress.captionText = "Hello, World!"
        XCTAssertEqual(iprogress.captionText, "Hello, World!")
    }

    // Mock delegate for testing purposes
    class MockProgressHUDDelegate: iProgressHUDDelegate {}

    func test_NVActivityIndicatorType() {
        // Test the newly exposed property of NVActivityIndicatorType
        XCTAssertEqual(NVActivityIndicatorType.allTypes.count, 33)
        let expected: [NVActivityIndicatorType] = [
            .blank, .ballPulse, .ballGridPulse, .ballClipRotate, .squareSpin, .ballClipRotatePulse,
            .ballClipRotateMultiple, .ballPulseRise, .ballRotate, .cubeTransition, .ballZigZag,
            .ballZigZagDeflect, .ballTrianglePath, .ballScale, .lineScale, .lineScaleParty,
            .ballScaleMultiple, .ballPulseSync, .ballBeat, .lineScalePulseOut,
            .lineScalePulseOutRapid, .ballScaleRipple, .ballScaleRippleMultiple,
            .ballSpinFadeLoader, .lineSpinFadeLoader, .triangleSkewSpin, .pacman, .ballGridBeat,
            .semiCircleSpin, .ballRotateChase, .orbit, .audioEqualizer, .circleStrokeSpin,
        ]
        XCTAssertEqual(NVActivityIndicatorType.allTypes, expected)
    }
}
