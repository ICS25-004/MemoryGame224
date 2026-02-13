import SwiftUI

/// A button representing a single tile in the memory game grid.
///
/// Displays the tile's contents with appropriate colors and icons based on game state.
/// Responds to taps by invoking the provided closure.
struct TileButton: View {
	/// SF Symbol name for hidden tiles during gameplay.
	private static let hiddenTileIcon = "questionmark.app"
	
	/// The tile to display.
	let tile: Tile
	
	/// Whether treasures are currently visible (memorization phase).
	let treasuresVisible: Bool
	
	/// The currently selected suit for determining treasure icon colors.
	let selectedSuit: Suit
	
	/// Closure called when the tile is tapped.
	let onTap: (Tile) -> Void
	
	var body: some View {
		Button {
			onTap(tile)
		} label: {
			Image(systemName: tileImageName)
				.font(.largeTitle)
				.foregroundStyle(tileColor)
		}
		.accessibilityIdentifier("TileGridView_Tile")
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
	
	/// Determines the SF Symbol name to display for the tile based on game state.
	///
	/// Shows the tile's actual contents during memorization phase or after it's revealed.
	/// Shows a question mark icon for hidden tiles during gameplay.
	///
	/// - Returns: SF Symbol name string (e.g., "suit.heart.fill" or "questionmark.app").
	private var tileImageName: String {
		if treasuresVisible || tile.isRevealed { tile.contents }
		else { TileButton.hiddenTileIcon }
	}
	
	/// Determines the color to apply to the tile's icon.
	///
	/// Returns yellow for bonus tiles when visible, the suit's color (red or black) when
	/// the tile is visible and contains the selected treasure, or primary color for all other cases.
	///
	/// - Returns: Color for the tile icon (yellow for bonus, suit color, or primary).
	private var tileColor: Color {
		if (treasuresVisible || tile.isRevealed) && tile.isBonus { .yellow }
		else if (treasuresVisible || tile.isRevealed) && tile.contents == selectedSuit.iconName { selectedSuit.color }
		else { .primary }
	}
}
