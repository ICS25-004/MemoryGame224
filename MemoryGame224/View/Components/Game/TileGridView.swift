import SwiftUI

/// Displays the game board as an interactive grid of tiles.
///
/// Renders all tiles in a responsive grid layout where each tile can be tapped to reveal
/// its contents. The appearance of tiles changes based on game state (memorization vs. gameplay).
struct TileGridView: View {
	/// SF Symbol name for hidden tiles during gameplay.
	private static let hiddenTileIcon = "questionmark.app"
	
	/// The game board containing all tiles.
	let board: Board
	
	/// Whether treasures are currently visible (memorization phase).
	let treasuresVisible: Bool
	
	/// The currently selected suit for determining treasure icon colors.
	let selectedSuit: Suit
	
	/// Closure called when a tile is tapped.
	let onTileTap: (Tile) -> Void
	
	var body: some View {
		Grid {
			ForEach(board.tiles.indices, id: \.self) { rowIndex in
				GridRow {
					ForEach(board.tiles[rowIndex], id: \.id) { tile in
						Button {
							onTileTap(tile)
						} label: {
							Image(systemName: getTileImageName(tile))
								.font(.largeTitle)
								.foregroundStyle(getTileColor(tile))
						}
						.accessibilityIdentifier("TileGridView_Tile")
						.frame(maxWidth: .infinity, maxHeight: .infinity)
					}
				}
			}
		}
		.frame(maxHeight: .infinity)
	}
	
	/// Determines the SF Symbol name to display for a tile based on game state.
	///
	/// Shows the tile's actual contents during memorization phase or after it's revealed.
	/// Shows a question mark icon for hidden tiles during gameplay.
	///
	/// - Parameter tile: The tile to determine the icon for.
	/// - Returns: SF Symbol name string (e.g., "suit.heart.fill" or "questionmark.app").
	private func getTileImageName(_ tile: Tile) -> String {
		if treasuresVisible || tile.isRevealed {
			tile.contents
		} else {
			TileGridView.hiddenTileIcon
		}
	}
	
	/// Determines the color to apply to a tile's icon.
	///
	/// Returns yellow for bonus tiles when visible, the suit's color (red or black) when
	/// the tile is visible and contains the selected treasure, or primary color for all other cases.
	///
	/// - Parameter tile: The tile to determine the color for.
	/// - Returns: Color for the tile icon (yellow for bonus, suit color, or primary).
	private func getTileColor(_ tile: Tile) -> Color {
		if (treasuresVisible || tile.isRevealed) && tile.isBonus {
			.yellow
		} else if (treasuresVisible || tile.isRevealed)
				&& tile.contents == selectedSuit.iconName {
			selectedSuit.color
		} else {
			.primary
		}
	}
}
