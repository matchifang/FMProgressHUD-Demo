//
//  FMProgressHUDDemoUITests.swift
//  FMProgressHUDDemoUITests
//
//  Created by Matchima Ditthawibun on 19/5/21.
//

import XCTest

class FMProgressHUDDemoUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testUIElementsAreVisible() {
        XCTAssertTrue(MainPage.showNormalButton.exists && MainPage.showNormalButton.isHittable)
        XCTAssertTrue(MainPage.showWithStatus.exists && MainPage.showWithStatus.isHittable)
        XCTAssertTrue(MainPage.showWithProgress.exists && MainPage.showWithProgress.isHittable)
        XCTAssertTrue(MainPage.showInfoWithStatus.exists && MainPage.showInfoWithStatus.isHittable)
        XCTAssertTrue(MainPage.showSuccessWithStatus.exists && MainPage.showSuccessWithStatus.isHittable)
        XCTAssertTrue(MainPage.showErrorWithStatus.exists && MainPage.showErrorWithStatus.isHittable)
        XCTAssertTrue(MainPage.showCustomImageWithStatus.exists && MainPage.showCustomImageWithStatus.isHittable)
        XCTAssertTrue(MainPage.dismissButton.exists && MainPage.dismissButton.isHittable)
        
        XCTAssertTrue(MainPage.keyboardSegmentedControl.exists && MainPage.keyboardSegmentedControl.isHittable)
        XCTAssertTrue(MainPage.animationTypeSegmentedControl.exists && MainPage.animationTypeSegmentedControl.isHittable)
        XCTAssertTrue(MainPage.styleSegmentedControl.exists && MainPage.styleSegmentedControl.isHittable)
        XCTAssertTrue(MainPage.maskSegmentedControl.exists && MainPage.maskSegmentedControl.isHittable)
        XCTAssertTrue(MainPage.ringThicknessSlider.exists && MainPage.ringThicknessSlider.isHittable)
        XCTAssertTrue(MainPage.imageWidthSlider.exists && MainPage.imageWidthSlider.isHittable)
        XCTAssertTrue(MainPage.imageHeightSlider.exists && MainPage.imageHeightSlider.isHittable)
        XCTAssertTrue(MainPage.allowInteractionSwitch.exists && MainPage.allowInteractionSwitch.isEnabled)
    }
    
    func testNormalSpinner() {
        MainPage.showNormalButton.tap()
        
        // Check that flat spinner is shown correctly
        MainPage.assertHUDisVisible()
        XCTAssertTrue(MainPage.flatSpinner.exists)
        XCTAssertFalse(MainPage.nativeSpinner.exists)
        XCTAssertTrue(MainPage.dismissButton.isHittable)
        
        // Check that allow user interaction works
        MainPage.allowInteractionSwitch.tap()
        XCTAssertFalse(MainPage.dismissButton.isHittable)
        MainPage.allowInteractionSwitch.tap()
        
        // Check that native spinner is shown correctly
        MainPage.animationTypeSegmentedControl.buttons["Native"].firstMatch.tap()
        MainPage.assertHUDisVisible()
        XCTAssertTrue(MainPage.nativeSpinner.exists)
        XCTAssertFalse(MainPage.flatSpinner.exists)
        
        
        MainPage.dismissButton.tap()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
