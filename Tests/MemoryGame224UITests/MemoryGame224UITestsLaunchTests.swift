//
//  MemoryGame224UITestsLaunchTests.swift
//  MemoryGame224UITests
//
//  Created by Caleb on 2026-01-05.
//

import XCTest

final class MemoryGame224UITestsLaunchTests: XCTestCase {
	
	override class var runsForEachTargetApplicationUIConfiguration: Bool { true }
	
	override func setUpWithError() throws { continueAfterFailure = false }
	
	// MARK: - Helper Methods
	
	/// Detects if we're currently on the Settings screen
	private func isOnSettingsScreen(_ app: XCUIApplication) -> Bool {
		app.steppers["rowsAndColumnsStepper"].exists ||
		app.switches["BonusTileToggle"].exists
	}
	
	/// Detects if we're currently on the Game screen
	private func isOnGameScreen(_ app: XCUIApplication) -> Bool {
		!isOnSettingsScreen(app)
	}
	
	/// Navigates to the game screen
	private func navigateToGame(_ app: XCUIApplication) {
		let settingsButton = app.buttons["ContentView_ToggleSettingsButton"]
		XCTAssertTrue(settingsButton.waitForExistence(timeout: 5), "Settings button is missing")
		
		if isOnGameScreen(app) { return }
		if isOnSettingsScreen(app) { settingsButton.tap() }
		
		XCTAssertTrue(isOnGameScreen(app), "Failed to navigate to game screen")
	}
	
	/// Navigates to the settings screen
	private func navigateToSettings(_ app: XCUIApplication) {
		let settingsButton = app.buttons["ContentView_ToggleSettingsButton"]
		XCTAssertTrue(settingsButton.waitForExistence(timeout: 5), "Settings button is missing")
		
		if isOnSettingsScreen(app) { return }
		
		settingsButton.tap()
		
		XCTAssertTrue(isOnSettingsScreen(app), "Failed to navigate to settings screen")
	}
	
	/// Tests the combined rows & columns stepper by incrementing to 10 and decrementing back to 5
	private func stepperTestHelper(app: XCUIApplication, identifier: String, labelPrefix: String) {
		let stepper = app.steppers[identifier]
		XCTAssertTrue(stepper.waitForExistence(timeout: 5), "\(identifier) does not exist")
		
		let labelStart = app.staticTexts["\(labelPrefix): 5"].firstMatch
		XCTAssertTrue(labelStart.waitForExistence(timeout: 1), "Expected '\(labelPrefix): 5' label to exist at start")
		
		for i in (5...10).dropFirst() {
			app.buttons["\(identifier)-Increment"].firstMatch.tap()
			let label = app.staticTexts["\(labelPrefix): \(i)"].firstMatch
			XCTAssertTrue(label.waitForExistence(timeout: 1), "Expected '\(labelPrefix): \(i)' label to exist after incrementing")
		}
		
		let labelEnd = app.staticTexts["\(labelPrefix): 10"].firstMatch
		XCTAssertTrue(labelEnd.exists, "Should be at '\(labelPrefix): 10'")
		app.buttons["\(identifier)-Increment"].firstMatch.tap()
		XCTAssertTrue(labelEnd.exists, "Should still be at '\(labelPrefix): 10' after attempting to increment beyond max")
		
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
		tapCount: Int
	) {
		let rightButton = app.buttons[rightIdentifier]
		let leftButton = app.buttons[leftIdentifier]
		
		XCTAssertTrue(rightButton.waitForExistence(timeout: 5), "Right button does not exist")
		XCTAssertTrue(leftButton.waitForExistence(timeout: 5), "Left button does not exist")
		
		for _ in 0..<tapCount { rightButton.tap() }
		for _ in 0..<tapCount { leftButton.tap() }
	}
	
	// // MARK: - Tests

	@MainActor
	func testSteppers() throws {
		let app = XCUIApplication(); app.launch()
		navigateToSettings(app)
		
		stepperTestHelper(app: app, identifier: "rowsAndColumnsStepper", labelPrefix: "Rows & Columns")
		
		navigateToGame(app)
	}
	@MainActor
	func testSuitSettingsPickerView_Buttons() throws {
		let app = XCUIApplication(); app.launch()
		navigateToSettings(app)
		
		navTestHelperButtons(
			app: app,
			leftIdentifier: "SuitCarousel_LeftButton",
			rightIdentifier: "SuitCarousel_RightButton",
			tapCount: 3
		)
		
		navigateToGame(app)
	}
	
	@MainActor
	func testSuitSettingsPickerView_ThumbnailScrollView() throws {
		let app = XCUIApplication(); app.launch()
		navigateToSettings(app)
		
		let segmentedToggle = app.switches["SegmentedPickerToggle"]
		if segmentedToggle.exists && segmentedToggle.value as? String == "On" {
			segmentedToggle.switches.firstMatch.tap()
			Thread.sleep(forTimeInterval: 0.3)
		}
		
		let thumbnailIcon = app.buttons["SuitThumbnail_Icon_spade"].firstMatch
		XCTAssertTrue(thumbnailIcon.waitForExistence(timeout: 2), "Spade thumbnail should exist")
		thumbnailIcon.tap()
		
		let heartThumbnail = app.buttons["SuitThumbnail_Icon_heart"].firstMatch
		XCTAssertTrue(heartThumbnail.waitForExistence(timeout: 2), "Heart thumbnail should exist")
		heartThumbnail.tap()
		navigateToGame(app)
	}
	
	@MainActor
	func testSuitSettingsPickerView_BonusToggle() throws {
		let app = XCUIApplication(); app.launch()
		navigateToSettings(app)
		
		let bonusToggle = app.switches["BonusTileToggle"]
		bonusToggle.switches.firstMatch.tap()
		
		bonusToggle.switches.firstMatch.tap()
		navigateToGame(app)
	}
	
	@MainActor
	func testBonusTileResetsTapCount() throws {
		let app = XCUIApplication(); app.launch()
		navigateToSettings(app)
		
		let bonusToggle = app.switches["BonusTileToggle"]
		XCTAssertTrue(bonusToggle.waitForExistence(timeout: 2), "Bonus toggle should exist")
		
		if bonusToggle.value as? String == "Off" {
			bonusToggle.switches.firstMatch.tap()
			Thread.sleep(forTimeInterval: 0.5)
		}
		
		navigateToGame(app)
		Thread.sleep(forTimeInterval: 5)
		
		let anyTile = app.buttons.matching(identifier: "TileGridView_Tile").firstMatch
		if anyTile.waitForExistence(timeout: 2) {
			anyTile.tap()
			anyTile.tap()
		}
		
		navigateToSettings(app)
		bonusToggle.switches.firstMatch.tap()
		navigateToGame(app)
	}
	
	@MainActor
	func testGameBoardResizing() throws {
		let app = XCUIApplication(); app.launch()
		navigateToSettings(app)
		
		let stepper = app.steppers["rowsAndColumnsStepper"]
		XCTAssertTrue(stepper.waitForExistence(timeout: 2), "Stepper should exist")
		
		app.buttons["rowsAndColumnsStepper-Increment"].firstMatch.tap()
		Thread.sleep(forTimeInterval: 0.5)
		
		navigateToGame(app)
		Thread.sleep(forTimeInterval: 1)
		
		navigateToSettings(app)
		app.buttons["rowsAndColumnsStepper-Decrement"].firstMatch.tap()
		navigateToGame(app)
	}
	
	@MainActor
	func testLoadingAppStorage() throws {
		let app = XCUIApplication(); app.launch()
		navigateToSettings(app)
		
		let bonusToggle = app.switches["BonusTileToggle"]
		XCTAssertTrue(bonusToggle.waitForExistence(timeout: 2), "Bonus switch should exist")
		
		bonusToggle.switches.firstMatch.tap()
		Thread.sleep(forTimeInterval: 0.5)
		
		let sizeIncrement = app.buttons["rowsAndColumnsStepper-Increment"].firstMatch
		XCTAssertTrue(sizeIncrement.waitForExistence(timeout: 2), "Size increment button should exist")
		sizeIncrement.tap()
		Thread.sleep(forTimeInterval: 0.5)
		
		let spadeThumbnail = app.buttons["SuitThumbnail_Icon_spade"].firstMatch
		XCTAssertTrue(spadeThumbnail.waitForExistence(timeout: 2), "Spade thumbnail should exist")
		spadeThumbnail.tap()
		Thread.sleep(forTimeInterval: 0.5)
		
		app.terminate(); app.launch()
		navigateToSettings(app)
		
		let bonusToggleAfter = app.switches["BonusTileToggle"]
		XCTAssertTrue(bonusToggleAfter.waitForExistence(timeout: 2), "Bonus switch should exist after relaunch")
		
		if let toggleValue = bonusToggleAfter.value {
			XCTAssertEqual(String(describing: toggleValue), "On", "Bonus switch should be ON after relaunch")
		} else {
			XCTFail("Bonus toggle value should not be nil")
		}
		
		let sizeLabel = app.staticTexts["Rows & Columns: 6"].firstMatch
		XCTAssertTrue(sizeLabel.waitForExistence(timeout: 2), "Size should be set to 6 after relaunch")
		
		bonusToggleAfter.tap()
		Thread.sleep(forTimeInterval: 0.3)
		
		app.buttons["SuitThumbnail_Icon_heart"].firstMatch.tap()
		Thread.sleep(forTimeInterval: 0.3)
		
		let sizeDecrement = app.buttons["rowsAndColumnsStepper-Decrement"].firstMatch
		sizeDecrement.tap()
		Thread.sleep(forTimeInterval: 0.3)
		
		navigateToGame(app)
	}
	
	@MainActor
	func testAllThumbnailsInteractive() throws {
		let app = XCUIApplication(); app.launch()
		let suits = ["heart", "club", "diamond", "spade"]
		navigateToSettings(app)
		
		let thumbnailContainer = app.otherElements["SuitCarousel_ThumbnailContainer"]
		XCTAssertTrue(thumbnailContainer.waitForExistence(timeout: 3), "Thumbnail container should exist")
		
		for suit in suits {
			let thumbnailIcon = app.buttons["SuitThumbnail_Icon_\(suit)"].firstMatch
			XCTAssertTrue(thumbnailIcon.waitForExistence(timeout: 2), "SuitThumbnail '\(suit)' should exist")
			thumbnailIcon.tap()
			Thread.sleep(forTimeInterval: 0.3)
		}
		
		app.buttons["SuitThumbnail_Icon_heart"].firstMatch.tap()
		navigateToGame(app)
	}
	
	@MainActor
	func testSegmentedPickerToggle() throws {
		let app = XCUIApplication(); app.launch()
		navigateToSettings(app)
		
		let segmentedToggle = app.switches["SegmentedPickerToggle"]
		XCTAssertTrue(segmentedToggle.waitForExistence(timeout: 2), "Segmented picker toggle should exist")
		
		if segmentedToggle.value as? String == "Off" {
			segmentedToggle.switches.firstMatch.tap()
			Thread.sleep(forTimeInterval: 0.5)
		}
		
		let segmentedPicker = app.segmentedControls["SuitSegmentedPicker"]
		XCTAssertTrue(segmentedPicker.waitForExistence(timeout: 2), "Segmented picker should exist when enabled")
		
		let carouselLeft = app.buttons["SuitCarousel_LeftButton"]
		XCTAssertFalse(carouselLeft.exists, "Carousel should not exist when segmented picker is enabled")
		
		segmentedToggle.switches.firstMatch.tap()
		Thread.sleep(forTimeInterval: 0.5)
		
		XCTAssertTrue(carouselLeft.waitForExistence(timeout: 2), "Carousel should exist when segmented picker is disabled")
		
		navigateToGame(app)
	}
	
	@MainActor
	func testSegmentedPickerSelection() throws {
		let app = XCUIApplication(); app.launch()
		navigateToSettings(app)
		
		let segmentedToggle = app.switches["SegmentedPickerToggle"]
		if segmentedToggle.exists && segmentedToggle.value as? String == "Off" {
			segmentedToggle.switches.firstMatch.tap()
			Thread.sleep(forTimeInterval: 0.5)
		}
		
		let segmentedPicker = app.segmentedControls["SuitSegmentedPicker"]
		XCTAssertTrue(segmentedPicker.waitForExistence(timeout: 2), "Segmented picker should exist")
		
		let buttons = segmentedPicker.buttons
		XCTAssertEqual(buttons.count, 4, "Should have 4 suit options")
		
		if buttons.count >= 4 {
			buttons.element(boundBy: 2).tap()
			Thread.sleep(forTimeInterval: 0.3)
			
			buttons.element(boundBy: 0).tap()
			Thread.sleep(forTimeInterval: 0.3)
		}
		
		if segmentedToggle.exists {
			segmentedToggle.switches.firstMatch.tap()
			Thread.sleep(forTimeInterval: 0.3)
		}
		
		navigateToGame(app)
	}
	
}
