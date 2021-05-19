//
//  MainPage.swift
//  FMProgressHUDDemoUITests
//
//  Created by Matchima Ditthawibun on 19/5/21.
//

import XCTest

struct MainPage {
    
    // Basic UI Elements
    static let buttons = XCUIApplication().buttons
    static let otherElements = XCUIApplication().otherElements
    static let segmentedControls = XCUIApplication().segmentedControls
    static let sliders = XCUIApplication().sliders
    static let switches = XCUIApplication().switches
    
    // Show HUD Buttons
    static var showNormalButton = buttons["show normal"].firstMatch
    static var showWithStatus = buttons["show with status"].firstMatch
    static var showWithProgress = buttons["show with progress"].firstMatch
    static var showInfoWithStatus = buttons["show info with status"].firstMatch
    static var showSuccessWithStatus = buttons["show success with status"].firstMatch
    static var showErrorWithStatus = buttons["show error with status"].firstMatch
    static var showCustomImageWithStatus = buttons["show custom image with status"].firstMatch
    static var dismissButton = buttons["dismiss"].firstMatch
    
    // HUD Configurations
    static var keyboardSegmentedControl = segmentedControls["keyboardSegmentedControl"].firstMatch
    static var animationTypeSegmentedControl = segmentedControls["animationTypeSegmentedControl"].firstMatch
    static var styleSegmentedControl = segmentedControls["styleSegmentedControl"].firstMatch
    static var maskSegmentedControl = segmentedControls["maskSegmentedControl"].firstMatch
    static var ringThicknessSlider = sliders["ringThicknessSlider"].firstMatch
    static var imageWidthSlider = sliders["imageWidthSlider"].firstMatch
    static var imageHeightSlider = sliders["imageHeightSlider"].firstMatch
    static var allowInteractionSwitch = switches["allowInteractionSwitch"].firstMatch
    
    // HUD Elements
    static var backgroundView = otherElements["FMProgressHUD_backgroundView"].firstMatch
    static var hudView = otherElements["FMProgressHUD_hudView"].firstMatch
    static var nativeSpinner = otherElements["FMProgressHUD_nativeSpinner"].firstMatch
    static var flatSpinner = otherElements["FMProgressHUD_flatSpinner"].firstMatch
    static var statusLabel = otherElements["FMProgressHUD_statusLabel"].firstMatch
    static var progressView = otherElements["FMProgressHUD_progressView"].firstMatch
    static var imageView = otherElements["FMProgressHUD_imageView"].firstMatch
    
    static func assertHUDisVisible() {
        XCTAssertTrue(MainPage.backgroundView.exists)
        XCTAssertTrue(MainPage.hudView.exists)
    }
    
}
