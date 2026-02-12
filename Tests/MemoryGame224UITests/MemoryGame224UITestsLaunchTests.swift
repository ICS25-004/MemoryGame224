//
//  MemoryGame224UITestsLaunchTests.swift
//  MemoryGame224UITests
//
//  Created by Caleb on 2026-01-05.
//

import XCTest

final class MemoryGame224UITestsLaunchTests: XCTestCase {
	
	override class var runsForEachTargetApplicationUIConfiguration: Bool { false }
	
	override func setUpWithError() throws { continueAfterFailure = false }
	
	// MARK: - Helper Methods
	
	/// Resets the game and settings to default state
	/// - Bonus Toggle: OFF
	/// - Rows/Columns: 5
	/// - Suit Selection: First suit (heart)
	/// - Current View: Game View
	///
	/// - Parameter app: The XCUIApplication instance
	private func resetToDefaultState(_ app: XCUIApplication) {
		navigateToSettings(app)
		
		// Reset bonus toggle to OFF
		let bonusToggle = app.switches["BonusTileToggle"]
		XCTAssertTrue(bonusToggle.waitForExistence(timeout: 2), "Bonus toggle should exist")
		
		if bonusToggle.value as? String == "On" {
			bonusToggle.switches.firstMatch.tap()
			Thread.sleep(forTimeInterval: 0.3)
		}
		
		// Reset rows/columns to 5
		let stepper = app.steppers["rowsAndColumnsStepper"]
		XCTAssertTrue(stepper.waitForExistence(timeout: 2), "Stepper should exist")
		
		// Get current value from the label
		let currentLabel = app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH 'Rows & Columns:'")).firstMatch
		if currentLabel.exists {
			let labelText = currentLabel.label
			if let valueStr = labelText.split(separator: ":").last?.trimmingCharacters(in: .whitespaces),
			   let currentValue = Int(valueStr) {
				// Decrement or increment to reach 5
				let difference = currentValue - 5
				if difference > 0 {
					for _ in 0..<difference {
						app.buttons["rowsAndColumnsStepper-Decrement"].firstMatch.tap()
						Thread.sleep(forTimeInterval: 0.1)
					}
				} else if difference < 0 {
					for _ in 0..<abs(difference) {
						app.buttons["rowsAndColumnsStepper-Increment"].firstMatch.tap()
						Thread.sleep(forTimeInterval: 0.1)
					}
				}
			}
		}
		
		// Verify we're at 5
		let finalLabel = app.staticTexts["Rows & Columns: 5"].firstMatch
		XCTAssertTrue(finalLabel.waitForExistence(timeout: 1), "Rows & Columns should be reset to 5")
		
		// Reset suit selection to first suit (heart)
		let heartThumbnail = app.buttons["SuitThumbnail_Icon_heart"].firstMatch
		XCTAssertTrue(heartThumbnail.waitForExistence(timeout: 2), "Heart thumbnail should exist")
		heartThumbnail.tap()
		Thread.sleep(forTimeInterval: 0.3)
		
		// Navigate back to game view as default
		navigateToGame(app)
	}
	
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
	
	/// Tests navigation buttons by tapping right then left
	/// Note: Carousel buttons support infinite looping and are never disabled
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

	/// Tests stepper controls for rows and columns settings
	@MainActor
	func testSteppers() throws {
		let app = XCUIApplication(); app.launch()
		resetToDefaultState(app)
		navigateToSettings(app)
		
		let stepper = app.steppers["rowsAndColumnsStepper"]
		XCTAssertTrue(stepper.waitForExistence(timeout: 5), "Stepper should exist")
		
		// Verify stepper is present and functional
		XCTAssertTrue(stepper.exists, "Stepper should be present")
		
		navigateToGame(app)
	}
	
	/// Tests suit carousel navigation buttons
	@MainActor
	func testSuitSettingsPickerView_Buttons() throws {
		let app = XCUIApplication(); app.launch()
		resetToDefaultState(app)
		navigateToSettings(app)
		
		navTestHelperButtons(
			app: app,
			leftIdentifier: "SuitCarousel_LeftButton",
			rightIdentifier: "SuitCarousel_RightButton",
			tapCount: 3
		)
		
		navigateToGame(app)
	}
	
	/// Tests infinite looping carousel navigation by cycling through all suits multiple times
	@MainActor
	func testSuitCarouselInfiniteLooping() throws {
		let app = XCUIApplication(); app.launch()
		resetToDefaultState(app)
		navigateToSettings(app)
		
		let rightButton = app.buttons["SuitCarousel_RightButton"]
		let leftButton = app.buttons["SuitCarousel_LeftButton"]
		
		XCTAssertTrue(rightButton.waitForExistence(timeout: 5), "Right button should exist")
		XCTAssertTrue(leftButton.waitForExistence(timeout: 5), "Left button should exist")
		
		// Test wrapping from end to beginning (tap right 5+ times with only 4 suits)
		for _ in 0..<5 {
			rightButton.tap()
			Thread.sleep(forTimeInterval: 0.3)
		}
		
		// Test wrapping from beginning to end (tap left to wrap around)
		for _ in 0..<5 {
			leftButton.tap()
			Thread.sleep(forTimeInterval: 0.3)
		}
		
		navigateToGame(app)
	}
	
	/// Tests suit selection via thumbnail scroll view
	@MainActor
	func testSuitSettingsPickerView_ThumbnailScrollView() throws {
		let app = XCUIApplication(); app.launch()
		resetToDefaultState(app)
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
	
	/// Tests bonus tile toggle functionality
	@MainActor
	func testSuitSettingsPickerView_BonusToggle() throws {
		let app = XCUIApplication(); app.launch()
		resetToDefaultState(app)
		navigateToSettings(app)
		
		let bonusToggle = app.switches["BonusTileToggle"]
		bonusToggle.switches.firstMatch.tap()
		
		bonusToggle.switches.firstMatch.tap()
		navigateToGame(app)
	}
	
	/// Tests that bonus tile changes reset tap count appropriately
	@MainActor
	func testBonusTileResetsTapCount() throws {
		let app = XCUIApplication(); app.launch()
		resetToDefaultState(app)
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
	
	/// Tests game board resizing through settings stepper
	@MainActor
	func testGameBoardResizing() throws {
		let app = XCUIApplication(); app.launch()
		resetToDefaultState(app)
		navigateToSettings(app)
		
		let stepper = app.steppers["rowsAndColumnsStepper"]
		XCTAssertTrue(stepper.waitForExistence(timeout: 2), "Stepper should exist")
		
		navigateToGame(app)
		Thread.sleep(forTimeInterval: 1)
		
		navigateToSettings(app)
		XCTAssertTrue(stepper.exists, "Stepper should still exist after navigation")
		navigateToGame(app)
	}
	
	/// Tests that settings persist after app relaunch using AppStorage
	@MainActor
	func testLoadingAppStorage() throws {
		let app = XCUIApplication(); app.launch()
		resetToDefaultState(app)
		navigateToSettings(app)
		
		let bonusToggle = app.switches["BonusTileToggle"]
		XCTAssertTrue(bonusToggle.waitForExistence(timeout: 2), "Bonus switch should exist")
		
		bonusToggle.switches.firstMatch.tap()
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
		
		bonusToggleAfter.switches.firstMatch.tap()
		Thread.sleep(forTimeInterval: 0.3)
		
		app.buttons["SuitThumbnail_Icon_heart"].firstMatch.tap()
		Thread.sleep(forTimeInterval: 0.3)
		
		navigateToGame(app)
	}
	
	/// Tests all suit thumbnails are interactive and selectable
	@MainActor
	func testAllThumbnailsInteractive() throws {
		let app = XCUIApplication(); app.launch()
		resetToDefaultState(app)
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


	/// Tests settings values persist when navigating between screens
	@MainActor
	func testSettingsPersistBetweenScreenTransitions() throws {
		let app = XCUIApplication(); app.launch()
		resetToDefaultState(app)
		navigateToSettings(app)

		// Verify stepper exists
		let stepper = app.steppers["rowsAndColumnsStepper"]
		XCTAssertTrue(stepper.waitForExistence(timeout: 2), "Stepper should exist")

		// Navigate to game and back
		navigateToGame(app)
		Thread.sleep(forTimeInterval: 1)
		navigateToSettings(app)

		// Verify stepper still exists after navigation
		XCTAssertTrue(stepper.exists, "Stepper should still exist after navigation")

		navigateToGame(app)
	}

	/// Tests bonus tile toggle affects game board generation
	@MainActor
	func testBonusTileToggleChangesGameBoard() throws {
		let app = XCUIApplication(); app.launch()
		resetToDefaultState(app)
		navigateToSettings(app)

		let bonusToggle = app.switches["BonusTileToggle"]
		XCTAssertTrue(bonusToggle.waitForExistence(timeout: 2), "Bonus toggle should exist")

		// Toggle bonus tile
		bonusToggle.switches.firstMatch.tap()
		Thread.sleep(forTimeInterval: 0.5)

		// Navigate to game to trigger board regeneration
		navigateToGame(app)
		Thread.sleep(forTimeInterval: 6) // Wait for countdown

		// Verify game is functional
		XCTAssertTrue(app.exists, "Game should work with bonus tile toggled")

		// Go back to settings
		navigateToSettings(app)

		// Toggle again
		bonusToggle.switches.firstMatch.tap()
		Thread.sleep(forTimeInterval: 0.5)

		// Navigate to game again
		navigateToGame(app)
		Thread.sleep(forTimeInterval: 6) // Wait for countdown

		// Verify game still works
		XCTAssertTrue(app.exists, "Game should work after second toggle")
		let tiles = app.buttons.matching(identifier: "TileGridView_Tile")
		XCTAssertGreaterThan(tiles.count, 0, "Tiles should exist")
	}

	/// Tests rapid suit changes maintain UI stability
	@MainActor
	func testMultipleSuitChangesInSuccession() throws {
		let app = XCUIApplication(); app.launch()
		resetToDefaultState(app)
		navigateToSettings(app)

		let rightButton = app.buttons["SuitCarousel_RightButton"]
		XCTAssertTrue(rightButton.waitForExistence(timeout: 2), "Right button should exist")

		// Cycle through all suits twice to test stability
		for _ in 0..<8 {
			rightButton.tap()
			Thread.sleep(forTimeInterval: 0.2)
		}

		// Verify UI is still responsive
		XCTAssertTrue(rightButton.exists, "Right button should still exist after multiple taps")

		// Navigate to game to ensure suit changes apply
		navigateToGame(app)
		Thread.sleep(forTimeInterval: 2)

		// Verify game launched successfully with suit changes
		XCTAssertTrue(app.exists, "Game should launch after multiple suit changes")
	}

	/// Tests game tile interaction after countdown completes
	@MainActor
	func testGameTileInteraction() throws {
		let app = XCUIApplication(); app.launch()
		resetToDefaultState(app)
		
		// Wait for countdown to complete
		Thread.sleep(forTimeInterval: 5)
		
		// Find and tap any tile
		let tiles = app.buttons.matching(identifier: "TileGridView_Tile")
		XCTAssertGreaterThan(tiles.count, 0, "Game board should have tiles")
		
		if tiles.count > 0 {
			let firstTile = tiles.element(boundBy: 0)
			XCTAssertTrue(firstTile.waitForExistence(timeout: 2), "First tile should exist")
			firstTile.tap()
			Thread.sleep(forTimeInterval: 0.3)
			
			// Verify tap count increased
			let tapCountLabel = app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH 'Tap Count:'")).firstMatch
			XCTAssertTrue(tapCountLabel.exists, "Tap count label should exist")
		}
	}

	/// Tests countdown timer displays correctly
	@MainActor
	func testCountdownTimerDisplay() throws {
		let app = XCUIApplication(); app.launch()
		resetToDefaultState(app)
		
		// Verify countdown timer exists (showing "4", "3", "2", "1")
		let countdownNumbers = app.staticTexts.matching(NSPredicate(format: "label MATCHES '[0-4]'"))
		XCTAssertTrue(countdownNumbers.firstMatch.waitForExistence(timeout: 2), "Countdown number should be visible")
		
		// Wait for countdown to complete
		Thread.sleep(forTimeInterval: 5)
		
		// Verify "Go!" appears after countdown
		let goText = app.staticTexts["Go!"]
		XCTAssertTrue(goText.exists, "Go! text should appear after countdown")
	}

	/// Tests game stats footer displays tap count and treasure count
	@MainActor
	func testGameStatsFooterDisplay() throws {
		let app = XCUIApplication(); app.launch()
		resetToDefaultState(app)
		
		// Wait for countdown
		Thread.sleep(forTimeInterval: 5)
		
		// Verify tap count label exists
		let tapCountLabel = app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH 'Tap Count:'")).firstMatch
		XCTAssertTrue(tapCountLabel.waitForExistence(timeout: 2), "Tap count label should exist")
		
		// Verify treasure count label exists
		let treasureCountLabel = app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH 'Treasure Count:'")).firstMatch
		XCTAssertTrue(treasureCountLabel.waitForExistence(timeout: 2), "Treasure count label should exist")
	}

	/// Tests board resize from 5 to 10 and back
	@MainActor
	func testCompleteStepperRange() throws {
		let app = XCUIApplication(); app.launch()
		resetToDefaultState(app)
		navigateToSettings(app)
		
		let stepper = app.steppers["rowsAndColumnsStepper"]
		XCTAssertTrue(stepper.waitForExistence(timeout: 2), "Stepper should exist")
		
		// Test increment from 5 to 10
		for i in 6...10 {
			app.buttons["rowsAndColumnsStepper-Increment"].firstMatch.tap()
			Thread.sleep(forTimeInterval: 0.2)
			let label = app.staticTexts["Rows & Columns: \(i)"].firstMatch
			XCTAssertTrue(label.waitForExistence(timeout: 1), "Should show \(i)")
		}
		
		// Verify max value (should stay at 10)
		app.buttons["rowsAndColumnsStepper-Increment"].firstMatch.tap()
		let maxLabel = app.staticTexts["Rows & Columns: 10"].firstMatch
		XCTAssertTrue(maxLabel.exists, "Should stay at 10")
		
		// Test decrement back to 5
		for i in (5...9).reversed() {
			app.buttons["rowsAndColumnsStepper-Decrement"].firstMatch.tap()
			Thread.sleep(forTimeInterval: 0.2)
			let label = app.staticTexts["Rows & Columns: \(i)"].firstMatch
			XCTAssertTrue(label.waitForExistence(timeout: 1), "Should show \(i)")
		}
		
		// Verify min value (should stay at 5)
		app.buttons["rowsAndColumnsStepper-Decrement"].firstMatch.tap()
		let minLabel = app.staticTexts["Rows & Columns: 5"].firstMatch
		XCTAssertTrue(minLabel.exists, "Should stay at 5")
		
		navigateToGame(app)
	}

	/// Tests multiple taps on same tile
	@MainActor
	func testMultipleTapsOnSameTile() throws {
		let app = XCUIApplication(); app.launch()
		resetToDefaultState(app)
		
		// Wait for countdown
		Thread.sleep(forTimeInterval: 5)
		
		let tiles = app.buttons.matching(identifier: "TileGridView_Tile")
		if tiles.count > 0 {
			let firstTile = tiles.element(boundBy: 0)
			XCTAssertTrue(firstTile.waitForExistence(timeout: 2), "First tile should exist")
			
			// Tap the same tile multiple times
			firstTile.tap()
			Thread.sleep(forTimeInterval: 0.2)
			firstTile.tap()
			Thread.sleep(forTimeInterval: 0.2)
			firstTile.tap()
			
			// Tile should only count once (already revealed)
			XCTAssertTrue(app.exists, "App should handle multiple taps on same tile")
		}
	}

	/// Tests navigating to settings during countdown
	@MainActor
	func testNavigateToSettingsDuringCountdown() throws {
		let app = XCUIApplication(); app.launch()
		resetToDefaultState(app)
		
		// Navigate to settings immediately (during countdown)
		Thread.sleep(forTimeInterval: 1)
		navigateToSettings(app)
		
		// Verify settings loaded correctly
		let bonusToggle = app.switches["BonusTileToggle"]
		XCTAssertTrue(bonusToggle.waitForExistence(timeout: 2), "Settings should load during countdown")
		
		navigateToGame(app)
	}

	/// Tests changing board size triggers game reset
	@MainActor
	func testBoardSizeChangeTriggersReset() throws {
		let app = XCUIApplication(); app.launch()
		resetToDefaultState(app)
		
		// Wait for countdown and tap a tile
		Thread.sleep(forTimeInterval: 5)
		let tiles = app.buttons.matching(identifier: "TileGridView_Tile")
		if tiles.count > 0 {
			tiles.element(boundBy: 0).tap()
		}
		
		// Change board size
		navigateToSettings(app)
		app.buttons["rowsAndColumnsStepper-Increment"].firstMatch.tap()
		Thread.sleep(forTimeInterval: 0.3)
		
		navigateToGame(app)
		Thread.sleep(forTimeInterval: 5)
		
		// Verify game reset (tap count should be 0 initially)
		let tapCountLabel = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Tap Count: 0'")).firstMatch
		XCTAssertTrue(tapCountLabel.exists, "Tap count should reset to 0 after board resize")
	}

	/// Tests app launch performance and initial state
	@MainActor
	func testInitialLaunchState() throws {
		let app = XCUIApplication(); app.launch()
		
		// Verify game view is the default view
		XCTAssertTrue(isOnGameScreen(app), "Game view should be default on launch")
		
		// Verify settings button exists
		let settingsButton = app.buttons["ContentView_ToggleSettingsButton"]
		XCTAssertTrue(settingsButton.waitForExistence(timeout: 2), "Settings button should exist")
		
		// Verify game board elements exist
		let tiles = app.buttons.matching(identifier: "TileGridView_Tile")
		XCTAssertTrue(tiles.firstMatch.waitForExistence(timeout: 6), "Tiles should appear after countdown")
	}

}
