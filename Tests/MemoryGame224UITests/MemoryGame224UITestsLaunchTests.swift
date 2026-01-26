//
//  MemoryGame224UITestsLaunchTests.swift
//  MemoryGame224UITests
//
//  Created by Caleb on 2026-01-05.
//

import XCTest

final class MemoryGame224UITestsLaunchTests: XCTestCase {
	
	//Both dark mode and light mode
	override class var runsForEachTargetApplicationUIConfiguration: Bool { true }
	
	override func setUpWithError() throws { continueAfterFailure = false }
	
	// MARK: - Helper Methods
	/// Detects if we're currently on the Settings screen
	private func isOnSettingsScreen(_ app: XCUIApplication) -> Bool {
		app.steppers["RowStepper"].exists ||
		app.steppers["ColumnStepper"].exists ||
		app.switches["BonusTileToggle"].exists
	}
	
	/// Detects if we're currently on the Game screen
	private func isOnGameScreen(_ app: XCUIApplication) -> Bool {
		app.buttons["TabButtonsView_LeftButton"].exists ||
		app.buttons["TabButtonsView_RightButton"].exists ||
		app.otherElements["GameView_TabViewPages"].exists
	}
	
	
	private func navigateToGame(_ app: XCUIApplication) {
		let settingsButton = app.buttons["ContentView_ToggleSettingsButton"]
		XCTAssertTrue(settingsButton.waitForExistence(timeout: 5), "Settings button is missing")
		
		
		if isOnGameScreen(app) { return } //Already in game
		if isOnSettingsScreen(app) { settingsButton.tap() }
		
		XCTAssertTrue(isOnGameScreen(app),
									"Failed to navigate to game screen")
	}
	
	private func navigateToSettings(_ app: XCUIApplication) {
		let settingsButton = app.buttons["ContentView_ToggleSettingsButton"]
		XCTAssertTrue(settingsButton.waitForExistence(timeout: 5), "Settings button is missing")
		
		if isOnSettingsScreen(app) { return } //alreadt in settings
		
		settingsButton.tap()
		
		XCTAssertTrue(isOnSettingsScreen(app),
									"Failed to navigate to settings screen")
	}
	
	/// Tests a stepper by incrementing to 10 (and no higher), then decrementing to 5 (and no lower)
	private func stepperTestHelper(app: XCUIApplication, identifier: String, labelPrefix: String) {
		let stepper = app.steppers[identifier]
		XCTAssertTrue(stepper.waitForExistence(timeout: 5), "\(identifier) does not exist")
		
		
		let labelStart = app.staticTexts["\(labelPrefix): 5"].firstMatch // Verify starting at 5
		XCTAssertTrue(labelStart.waitForExistence(timeout: 1), "Expected '\(labelPrefix): 5' label to exist at start")
		
		// Increment from 5 (excluded) to 10
		for i in (5...10).dropFirst() {
			app.buttons["\(identifier)-Increment"].firstMatch.tap()
			let label = app.staticTexts["\(labelPrefix): \(i)"].firstMatch
			XCTAssertTrue(label.waitForExistence(timeout: 1), "Expected '\(labelPrefix): \(i)' label to exist after incrementing")
		}
		
		let labelEnd = app.staticTexts["\(labelPrefix): 10"].firstMatch // Verify we're at 10 and cannot go higher
		XCTAssertTrue(labelEnd.exists, "Should be at '\(labelPrefix): 10'")
		app.buttons["\(identifier)-Increment"].firstMatch.tap()
		XCTAssertTrue(labelEnd.exists, "Should still be at '\(labelPrefix): 10' after attempting to increment beyond max")
		
		
		// Teardown: Decrement from 10 to 5 (checking each value after decrementing)
		for i in (5...10).dropLast().reversed() {
			app.buttons["\(identifier)-Decrement"].firstMatch.tap()
			let label = app.staticTexts["\(labelPrefix): \(i)"].firstMatch
			XCTAssertTrue(label.waitForExistence(timeout: 1), "Expected '\(labelPrefix): \(i)' label to exist after decrementing")
		}
		XCTAssertTrue(labelStart.exists, "Should be back at '\(labelPrefix): 5'")
	}
	
	/// Tests navigation buttons by tapping right then left, returning to original position
	private func navTestHelperButtons(
		app: XCUIApplication,
		leftIdentifier: String,
		rightIdentifier: String,
		tapCount: Int,
	) {
		
		let rightButton = app.buttons[rightIdentifier]
		let leftButton = app.buttons[leftIdentifier]
		
		XCTAssertTrue(rightButton.waitForExistence(timeout: 5), "Right button does not exist")
		XCTAssertTrue(leftButton.waitForExistence(timeout: 5), "Left button does not exist")
		
		
		for _ in 0..<tapCount { rightButton.tap() }// Navigate right
		
		for _ in 0..<tapCount { leftButton.tap() } // Navigate back to the left
	}
	
	// // MARK: - Tests
	@MainActor
	func testSteppers() throws {
		let app = XCUIApplication(); app.launch()
		navigateToSettings(app)
		
		stepperTestHelper(app: app, identifier: "RowStepper", labelPrefix: "Rows")
		stepperTestHelper(app: app, identifier: "ColumnStepper", labelPrefix: "Columns")
		
		//Teardown:
		navigateToGame(app)
	}
	@MainActor
	func testSuitSettingsPickerView_Buttons() throws {
		let app = XCUIApplication(); app.launch()
		navigateToSettings(app)
		
		navTestHelperButtons(
			app: app,
			leftIdentifier: "SuitSettingsPickerView_LeftButton",
			rightIdentifier: "SuitSettingsPickerView_RightButton",
			tapCount: 3
		)
		
		//Teardown:
		navigateToGame(app)
	}
	
	@MainActor
	func testSuitSettingsPickerView_ThumbnailScrollView() throws {
		let app = XCUIApplication(); app.launch()
		navigateToSettings(app)
		
		
		// Tap spade thumbnail (the 4th one) - Using buttons since we have .isButton
		let thumbnailIcon = app.buttons["ThumbnailView_Icon_spade"].firstMatch
		XCTAssertTrue(thumbnailIcon.waitForExistence(timeout: 2), "Spade thumbnail should exist")
		thumbnailIcon.tap()
		
		// Teardown: Return to original thumbnail (heart) and navigate back to game
		let heartThumbnail = app.buttons["ThumbnailView_Icon_heart"].firstMatch
		XCTAssertTrue(heartThumbnail.waitForExistence(timeout: 2), "Heart thumbnail should exist")
		heartThumbnail.tap()
		navigateToGame(app)
	}
	
	@MainActor
	func testSuitSettingsPickerView_BonusSwitches() throws {
		let app = XCUIApplication(); app.launch()
		navigateToSettings(app)
		
		let bonusSwitch = app.switches["BonusTileToggle"].firstMatch
		bonusSwitch.tap()
		Thread.sleep(forTimeInterval: 0.5)
		
		// Teardown: Turn back off and navigate back to game
		bonusSwitch.tap()
		navigateToGame(app)
	}
	
	@MainActor
	func testSwipeTabViewPages() throws {
		let app = XCUIApplication(); app.launch()
		navigateToGame(app)
		
		let swipeCount = 6 //Ensure we DONT loop
		
		// Swipe left through tabs
		for _ in 0..<swipeCount {
			app.swipeLeft()
			Thread.sleep(forTimeInterval: 0.5)
		}
		
		// Teardown: Swipe right back to original tab
		for _ in 0..<swipeCount { app.swipeRight() }
	}
	
	@MainActor
	func testButtonTabViewPages() throws {
		let app = XCUIApplication(); app.launch()
		navigateToGame(app)
		
		navTestHelperButtons(
			app: app,
			leftIdentifier: "TabButtonsView_LeftButton",
			rightIdentifier: "TabButtonsView_RightButton",
			tapCount: 5 //see if looping works.
		)
	}
	
	
	@MainActor
	func testAllThumbnailsInteractive() throws {
		let app = XCUIApplication(); app.launch()
		let suits = ["heart", "club", "diamond", "spade"]
		navigateToSettings(app)
		
		let thumbnailScrollView = app.otherElements["SuitSettingsPickerView_ThumbnailScrollView"]
		XCTAssertTrue(thumbnailScrollView.waitForExistence(timeout: 3), "Thumbnail scroll view should exist")
		
		// Test each TabThumbnailView by tapping. Via added .isButton trait
		for suit in suits {
			let thumbnailIcon = app.buttons["ThumbnailView_Icon_\(suit)"].firstMatch
			XCTAssertTrue(thumbnailIcon.waitForExistence(timeout: 2), "TabThumbnailView '\(suit)' should exist")
			thumbnailIcon.tap(); Thread.sleep(forTimeInterval: 0.3) //Slight delay between taps
		}
		
		// Teardown:
		app.buttons["ThumbnailView_Icon_heart"].firstMatch.tap()
		navigateToGame(app)
	}
	
}
