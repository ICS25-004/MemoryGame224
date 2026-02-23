import SwiftUI

/// A single tile button view optimized for watchOS.
///
/// Displays the tile's contents with appropriate icon based on game state.
struct WatchTileButton: View {
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
			ZStack {
				Image(systemName: tileImageName)
					.font(.system(size: iconSize))
					.foregroundStyle(tileColor == .black ? .white : tileColor)
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.contentShape(Rectangle())
		}
		.buttonStyle(.plain)
		.aspectRatio(1, contentMode: .fit)
		.frame(minWidth: 0, minHeight: 0)
	}
	
	/// Determines the appropriate icon size.
	private var iconSize: CGFloat {
		// Make dotted circles slightly larger so they're more visible
		if (treasuresVisible || tile.isRevealed) && tile.contents == Tile.defaultIcon {
			return 20
		}
		return 20
	}
	
	/// Determines the SF Symbol name to display for the tile based on game state.
	private var tileImageName: String {
		if treasuresVisible || tile.isRevealed {
			tile.contents
		} else {
			"questionmark.circle.dashed"
		}
	}
	
	/// Determines the color to apply to the tile's icon.
	private var tileColor: Color {
		if (treasuresVisible || tile.isRevealed) && tile.isBonus {
			Suit.bonusColor
		} else if (treasuresVisible || tile.isRevealed),
				  let tileSuit = Suit.allCases.first(where: { $0.iconName == tile.contents }) {
			tileSuit.color
		} else if (treasuresVisible || tile.isRevealed) && tile.contents == Tile.defaultIcon {
			// Empty tiles (circle.dotted) - use gray for better visibility
			.gray
		} else {
			.primary
		}
	}
}

