//
//  MemoryGame226UITestsLaunchTests.swift
//  MemoryGame226UITests
//
//  Created by Caleb on 2026-01-05.
//

import XCTest

final class MemoryGame224UITestsLaunchTests: XCTestCase {
	
	override class var runsForEachTargetApplicationUIConfiguration: Bool {
		true
	}
	
	override func setUpWithError() throws {
		continueAfterFailure = false
	}
	
	// MARK: - Helper Methods
	
	/// Launches the app and navigates to the settings screen if not already there
	private func launchAndNavigateToSettings(_ app: XCUIApplication) {
		app.launch()
		let settingsButton = app.buttons["ContentView_ToggleSettingsButton"]
		XCTAssertTrue(settingsButton.waitForExistence(timeout: 5), "Settings button is missing")
		
		// Navigate to settings if showing game screen
		if !settingsButton.images.description.contains("Home") {
			settingsButton.tap()
		}
	}
	
	/// Launches the app and navigates to the game screen if not already there
	private func launchAndNavigateToGame(_ app: XCUIApplication) {
		app.launch()
		let settingsButton = app.buttons["ContentView_ToggleSettingsButton"]
		XCTAssertTrue(settingsButton.waitForExistence(timeout: 5), "Settings button is missing")
		
		// Navigate to game if showing settings screen
		if settingsButton.images.description.contains("Home") {
			settingsButton.tap()
			Thread.sleep(forTimeInterval: 0.5)
		}
	}
	
	/// Tests a stepper by decrementing and incrementing, returning to original state
	private func testStepper(app: XCUIApplication, identifier: String, tapCount: Int) {
		XCTAssertTrue(app.steppers[identifier].waitForExistence(timeout: 5), "\(identifier) does not exist")
		
		// Decrement
		for _ in 0..<tapCount {
			app.buttons["\(identifier)-Decrement"].firstMatch.tap()
		}
		
		// Increment back to original state
		for _ in 0..<tapCount {
			app.buttons["\(identifier)-Increment"].firstMatch.tap()
		}
	}
	
	/// Tests navigation buttons by tapping right then left, returning to original position
	private func testNavigationButtons(
		app: XCUIApplication,
		leftIdentifier: String,
		rightIdentifier: String,
		tapCount: Int,
		delay: TimeInterval = 0.3
	) {
		let rightButton = app.buttons[rightIdentifier]
		let leftButton = app.buttons[leftIdentifier]
		
		XCTAssertTrue(rightButton.waitForExistence(timeout: 5), "Right button does not exist")
		XCTAssertTrue(leftButton.waitForExistence(timeout: 5), "Left button does not exist")
		
		// Navigate right
		for _ in 0..<tapCount {
			rightButton.tap()
			Thread.sleep(forTimeInterval: delay)
		}
		
		// Navigate left back to original position
		for _ in 0..<tapCount {
			leftButton.tap()
			Thread.sleep(forTimeInterval: delay)
		}
	}
	
	// MARK: - Tests
	
	@MainActor
	func testRowsStepper() throws {
		let app = XCUIApplication()
		launchAndNavigateToSettings(app)
		testStepper(app: app, identifier: "RowStepper", tapCount: 7)
		
		// Teardown: Reset rows to default (5)
		for _ in 0..<10 {
			app.buttons["RowStepper-Decrement"].tap()
		}
		for _ in 0..<4 {
			app.buttons["RowStepper-Increment"].tap()
		}
		
		app.terminate()
	}
	
	@MainActor
	func testColumnStepper() throws {
		let app = XCUIApplication()
		launchAndNavigateToSettings(app)
		testStepper(app: app, identifier: "ColumnStepper", tapCount: 7)
		
		// Teardown: Reset columns to default (5)
		for _ in 0..<10 {
			app.buttons["ColumnStepper-Decrement"].tap()
		}
		for _ in 0..<4 {
			app.buttons["ColumnStepper-Increment"].tap()
		}
		
		app.terminate()
	}
	
	@MainActor
	func testSuitSettingsPickerView_Buttons() throws {
		let app = XCUIApplication()
		launchAndNavigateToSettings(app)
		testNavigationButtons(
			app: app,
			leftIdentifier: "SuitSettingsPickerView_LeftButton",
			rightIdentifier: "SuitSettingsPickerView_RightButton",
			tapCount: 3
		)
		
		// Teardown: Already returned to original position by testNavigationButtons
		
		app.terminate()
	}
	
	@MainActor
	func testSuitSettingsPickerView_ThumbnailScrollView() throws {
		let app = XCUIApplication()
		launchAndNavigateToSettings(app)
		
		// Tap thumbnail icon
		let thumbnailIcon = app.images["ThumbnailView_Icon_3"].firstMatch
		thumbnailIcon.tap()
		
		// Teardown: Return to original thumbnail (already done inline)
		app.images["ThumbnailView_Icon_0"].firstMatch.tap()
		
		app.terminate()
	}
	
	@MainActor
	func testSuitSettingsPickerView_BonusSwitches() throws {
		let app = XCUIApplication()
		launchAndNavigateToSettings(app)
		
		let bonusSwitch = app.switches["BonusTileToggle"].firstMatch
		
		bonusSwitch.tap() // Turn on
		
		// Teardown: Turn back off (return to default state)
		bonusSwitch.tap()
		
		app.terminate()
	}
	
	@MainActor
	func testSwipeTabViewPages() throws {
		let app = XCUIApplication()
		launchAndNavigateToGame(app)
		
		let swipeCount = 3
		
		// Swipe left through tabs
		for _ in 0..<swipeCount {
			app.swipeLeft(velocity: .slow)
			Thread.sleep(forTimeInterval: 0.5)
		}
		
		// Teardown: Swipe right back to original tab (already done inline)
		for _ in 0..<swipeCount {
			app.swipeRight(velocity: .slow)
			Thread.sleep(forTimeInterval: 0.5)
		}
		
		app.terminate()
	}
	
	@MainActor
	func testButtonTabViewPages() throws {
		let app = XCUIApplication()
		launchAndNavigateToGame(app)
		testNavigationButtons(
			app: app,
			leftIdentifier: "TabButtonsView_LeftButton",
			rightIdentifier: "TabButtonsView_RightButton",
			tapCount: 3
		)
		
		// Teardown: Already returned to original position by testNavigationButtons
		
		app.terminate()
	}
}
