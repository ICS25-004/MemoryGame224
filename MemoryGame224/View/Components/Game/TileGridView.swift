import SwiftUI

/// Displays the game board as an interactive grid of tiles.
///
/// Renders all tiles in a responsive grid layout where each tile can be tapped to reveal
/// its contents. The appearance of tiles changes based on game state (memorization vs. gameplay).
struct TileGridView: View {
	/// The game board containing all tiles.
	let board: Board
	
	/// Whether treasures are currently visible (memorization phase).
	let treasuresVisible: Bool
	
	/// The currently selected suit for determining treasure icon colors.
	let selectedSuit: Suit
	
	/// Closure called when a tile is tapped.
	let onTileTap: (Tile) -> Void
	
	var body: some View {
		Grid(horizontalSpacing: gridSpacing, verticalSpacing: gridSpacing) {
			ForEach(board.tiles.indices, id: \.self) { rowIndex in
				GridRow {
					ForEach(board.tiles[rowIndex], id: \.id) { tile in
						TileButton(
							tile: tile,
							treasuresVisible: treasuresVisible,
							selectedSuit: selectedSuit,
							boardSize: board.size,
							onTap: onTileTap
						)
					}
				}
			}
		}
		.aspectRatio(1, contentMode: .fit)
		.padding(gridPadding)
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
	
	/// Calculates adaptive spacing between tiles based on board size.
	///
	/// Larger boards get minimal spacing to maximize icon size.
	/// Smaller boards get more generous spacing for better visual separation.
	///
	/// - Returns: Spacing value in points (1-8).
	private var gridSpacing: CGFloat {
		let size = board.tiles.count
		switch size {
		case ...5: return 8
		case 6: return 6
		case 7: return 4
		case 8: return 3
		case 9: return 2
		default: return 1
		}
	}
	
	/// Calculates adaptive padding around the entire grid based on board size.
	///
	/// Larger boards get minimal padding to maximize space for larger icons.
	/// Smaller boards get more padding for better visual balance.
	///
	/// - Returns: Padding value in points (2-16).
	private var gridPadding: CGFloat {
		let size = board.tiles.count
		switch size {
		case ...5: return 16
		case 6: return 12
		case 7: return 8
		case 8: return 6
		case 9: return 4
		default: return 2
		}
	}
	

}
