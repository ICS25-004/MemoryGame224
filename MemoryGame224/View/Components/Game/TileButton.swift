import SwiftUI

/// A button representing a single tile in the memory game grid.
///
/// Displays the tile's contents with appropriate colors and icons based on game state.
/// Responds to taps by invoking the provided closure.
struct TileButton: View {
	/// The tile to display.
	let tile: Tile
	
	/// Whether treasures are currently visible (memorization phase).
	let treasuresVisible: Bool
	
	/// The currently selected suit for determining treasure icon colors.
	let selectedSuit: Suit
	
	/// The size of the board (n x n) for adaptive icon sizing.
	let boardSize: Int
	
	/// Closure called when the tile is tapped.
	let onTap: (Tile) -> Void
	
	var body: some View {
		Button {
			onTap(tile)
		} label: {
			Image(systemName: tileImageName)
				.font(.system(size: iconSize))
				.foregroundStyle(tileColor)
				.frame(width: iconSize, height: iconSize)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
		}
		.accessibilityIdentifier("TileGridView_Tile")
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.aspectRatio(1, contentMode: .fit)
	}
	
	/// Determines the SF Symbol name to display for the tile based on game state.
	///
	/// Shows the tile's actual contents during memorization phase or after it's revealed.
	/// Shows a question mark icon for hidden tiles during gameplay.
	///
	/// - Returns: SF Symbol name string (e.g., "suit.heart.fill" or "questionmark.app").
	private var tileImageName: String {
		if treasuresVisible || tile.isRevealed { tile.contents }
		else { Tile.hiddenIcon }
	}
	
	/// Determines the color to apply to the tile's icon.
	///
	/// Returns the bonus color for bonus tiles when visible, the appropriate suit color (red or black)
	/// when the tile is visible and contains a treasure, or primary color for all other cases.
	///
	/// - Returns: Color for the tile icon (bonus color, suit color, or primary).
	private var tileColor: Color {
		if (treasuresVisible || tile.isRevealed) && tile.isBonus { Suit.bonusColor }
		else if (treasuresVisible || tile.isRevealed),
						let tileSuit = Suit.allCases.first(where: {
							$0.iconName == tile.contents
						})
		{ tileSuit.color }
		else { .primary }
	}
	
	/// Calculates the appropriate icon size based on board dimensions.
	///
	/// Larger boards use moderately smaller icons, compensated by reduced spacing.
	/// Smaller boards use larger icons for better visibility.
	///
	/// - Returns: Font size in points for the SF Symbol icon.
	private var iconSize: CGFloat {
		switch boardSize {
		case ...5: return 32
		case 6: return 28
		case 7: return 26
		case 8: return 24
		case 9: return 22
		default: return 20
		}
	}
}
