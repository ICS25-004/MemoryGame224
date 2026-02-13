import SwiftUI
import Combine

/// The main game view displaying the memory game board.
///  
/// Orchestrates the game flow by coordinating timer, grid, and stats components.
/// Manages game state and delegates rendering to specialized child views.
struct GameBoardView: View {
	// MARK: - Constants
	
	/// Duration in seconds for the memorization countdown phase.
	private static let countdownDuration = 4

	/// Timer interval in seconds for countdown updates.
	private static let timerInterval: TimeInterval = 1
	
	// MARK: - Properties
	/// The board size (n x n) stored in UserDefaults.
	@AppStorage("rows") private var rowsAndColumns = 5
	
	/// Whether the board includes a bonus tile, stored in UserDefaults.
	@AppStorage("hasBonus") private var hasBonus: Bool = false
	
	/// The index of the currently selected suit in the suits array.
	@Binding var selectedSuitIndex: Int
	
	/// The current game board instance.
	/// Optional because it's initialized after view appears. Nil indicates no active game.
	@State private var board: Board?
	
	/// Whether treasure locations are currently visible to the player.
	/// True during the 4-second memorization phase, false during gameplay.
	@State private var showTreasure = true
	
	/// The number of tiles the player has tapped during the current game.
	/// Resets to zero on bonus tile activation and/or board reinitialization.
	@State private var tapCount: Int = 0
	
	/// Timer that fires every second during the countdown phase.
	/// Automatically connects on initialization and cancels after countdown completes.
	@State private var timer = Timer.publish(every: GameBoardView.timerInterval, on: .main, in: .common).autoconnect()
	
	/// The number of seconds elapsed since the countdown started.
	///
	/// Increases from 0 to countdownDuration, at which point treasures become hidden.
	@State private var elapsedTime: Int = 0
	
	/// The currently selected suit for treasure icons.
	///
	/// Safely accesses Suit.allCases using the selected index, clamping to valid range.
	private var selectedSuit: Suit {
		let suits = Array(Suit.allCases)
		return suits[min(max(selectedSuitIndex, 0), suits.count - 1)]
	}

	/// Tuple of settings that trigger board reinitialization.
	///
	/// Only includes board size and bonus tile setting. Suit selection does not
	/// trigger reinitialization since it only affects visual appearance, not board layout.
	private var gameSettings: String {
		"\(rowsAndColumns)-\(hasBonus)"
	}

	var body: some View {
		VStack {
			CountdownTimerView(
				isCountingDown: showTreasure,
				elapsedTime: elapsedTime,
				countdownDuration: GameBoardView.countdownDuration
			)
			
			if let board = board {
				TileGridView(
					board: board,
					treasuresVisible: showTreasure,
					selectedSuit: selectedSuit,
					onTileTap: handleTileTap
				)
			}
			
			Spacer()
			
			GameStatsFooter(
				tapCount: tapCount,
				treasureCount: board?.countUnrevealedTreasures() ?? 0
			)
		}
		.onAppear(perform: initializeBoard)
		.onChange(of: gameSettings, initializeBoard)
		.onReceive(timer) { _ in
			guard showTreasure else { return }
			elapsedTime += 1
			guard elapsedTime >= GameBoardView.countdownDuration else { return }
			showTreasure = false
			timer.upstream.connect().cancel()
		}
	}
	
	// MARK: - Private Methods
	
	/// Initializes or resets the game board to start a new game.
	///
	/// Creates a new board with current settings, makes treasures visible for memorization,
	/// resets the tap counter, and starts a new countdown timer.
	///
	/// - Note: Modifies board, treasuresVisible, tapCount, elapsedTime, and timer properties.
	private func initializeBoard() {
		board = Board(size: rowsAndColumns, treasure: selectedSuit.iconName, hasBonus: hasBonus)
		showTreasure = true
		tapCount = 0
		elapsedTime = 0
		timer = Timer.publish(every: GameBoardView.timerInterval, on: .main, in: .common).autoconnect()
	}
	
	/// Handles user tap events on tiles during gameplay.
	///
	/// Ignores taps during the memorization phase. Reveals unrevealed tiles and increments
	/// the tap count. If the tile is an unused bonus tile, activates the bonus effect by
	/// resetting the tap count instead of incrementing it.
	///
	/// - Parameter tile: The tile that was tapped by the user.
	/// - Note: Modifies the tile's isRevealed and bonusUsed properties, and the tapCount property.
	private func handleTileTap(_ tile: Tile) {
		guard !showTreasure, !tile.isRevealed else { return }
		
		tile.isRevealed = true

		if tile.isBonus && !tile.bonusUsed { tile.bonusUsed = true; tapCount = 0 }
		else { tapCount += 1 }
	}
}
