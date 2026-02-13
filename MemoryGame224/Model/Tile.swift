import Observation

/// Represents a single tile in the memory game board.
///
/// Each tile has content (empty, treasure, or bonus), tracks whether it has been revealed,
/// and manages bonus tile state. Tiles are observable and identifiable for use in SwiftUI.
@Observable class Tile: Identifiable {
	// MARK: - Constants
	
	/// Default SF Symbol name for empty tiles.
	static let defaultIcon = "circle.dotted"
	
	// MARK: - Properties
	/// The content displayed on the tile as an SF Symbol name.
	/// Defaults to "circle.dotted" for empty tiles. May be set to a treasure icon
	/// (e.g., "suit.heart.fill") or bonus icon (e.g., "star.hexagon.fill").
	var contents: String = Tile.defaultIcon
	
	/// Whether the tile has been revealed by the user.
	///
	/// When false, the tile's contents are hidden. When true, the contents are visible.
	/// Once set to true, remains true for the duration of the game.
	var isRevealed: Bool = false
	
	/// Whether this tile is the special bonus tile.
	///
	/// Only one tile per board should have this set to true. Bonus tiles provide
	/// special game mechanics when revealed.
	var isBonus: Bool = false
	
	/// Whether the bonus tile's special effect has been activated.
	///
	/// Bonus tiles can only trigger their effect once per game. This flag prevents
	/// multiple activations if the bonus tile is tapped again.
	var bonusUsed: Bool = false
}

