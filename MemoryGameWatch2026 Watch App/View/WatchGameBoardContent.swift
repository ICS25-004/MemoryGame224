import SwiftUI

/// The game board content view optimized for watchOS.
///
/// Displays a compact 5x5 grid with countdown and stats.
struct WatchGameBoardContent: View {
	/// The current game board instance.
	let board: Board?
	
	/// Whether treasure locations are currently visible to the player.
	let showTreasure: Bool
	
	/// The number of seconds elapsed since the countdown started.
	let elapsedTime: Int
	
	/// Duration in seconds for the memorization countdown phase.
	let countdownDuration: Int
	
	/// The currently selected suit for treasure icons.
	let selectedSuit: Suit
	
	/// The number of tiles the player has tapped during the current game.
	let tapCount: Int
	
	/// Closure called when a tile is tapped.
	let onTileTap: (Tile) -> Void
	
	var body: some View {
		VStack(spacing: 2) {
			// 5x5 Grid with minimal spacing
			if let board = board {
				LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 2), count: 5), spacing: 2) {
					ForEach(board.tiles.flatMap { $0 }) { tile in
						WatchTileButton(
							tile: tile,
							treasuresVisible: showTreasure,
							selectedSuit: selectedSuit,
							onTap: onTileTap
						)
						.aspectRatio(1, contentMode: .fit)
						.clipped()
					}
				}
			}
			
			// Footer - shows countdown during memorization, stats during gameplay
			if showTreasure {
				Text("\(countdownDuration - elapsedTime)")
					.font(.title3)
					.foregroundStyle(.secondary)
					.padding(.top, 2)
			} else {
				HStack(spacing: 16) {
					Text("Picks: \(tapCount)")
						.font(.caption2)
					Text("Left: \(board?.countUnrevealedTreasures() ?? 0)")
						.font(.caption2)
				}
				.padding(.top, 2)
			}
		}
	}
}
#Preview {
	WatchGameBoardContent(
		board: Board(size: 5, treasure: Suit.heart.iconName, hasBonus: true),
		showTreasure: false,
		elapsedTime: 2,
		countdownDuration: 4,
		selectedSuit: .heart,
		tapCount: 3,
		onTileTap: { _ in }
	)
}

