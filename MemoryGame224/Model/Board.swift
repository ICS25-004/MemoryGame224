import Observation

/// Represents the game board containing a grid of tiles for the memory game.
///
/// The board manages an n x n grid of tiles, randomly placing treasures and an optional
/// bonus tile. Once created, the board's size and treasure type cannot be changed.
@Observable class Board {
	// MARK: - Constants
	
	/// Minimum allowed board size.
	private static let minimumSize = 5
	
	/// Maximum allowed board size.
	private static let maximumSize = 10
	
	/// Percentage of tiles that contain treasures (0.25 = 25%).
	private static let treasurePercentage = 0.25
	
	/// Default SF Symbol name for empty tiles.
	private static let emptyTileIcon = "circle.dotted"
	
	/// SF Symbol name for bonus tiles.
	private static let bonusTileIcon = "star.hexagon.fill"
	
	// MARK: - Properties
	
	/// The size of the board (n x n).
	///
	/// Valid sizes range from 5 to 10, creating grids from 25 to 100 tiles.
	let size: Int
	
	/// 2D array of tiles representing the game board.
	///
	/// Organized as rows and columns, where tiles[row][column] accesses a specific tile.
	/// The array is populated during initialization with all tiles configured.
	var tiles: [[Tile]] = []
	
	/// Stores the SF Symbol name that represents treasures on the board.
	let treasure: String
	
	/// Whether the board has a bonus tile.
	/// When true, one additional special tile with bonus functionality is placed.
	let hasBonus: Bool
	
	/// Initializes a new board with the specified configuration.
	///
	/// Creates an n x n grid of tiles, randomly distributes treasures on 25% of tiles,
	/// and optionally places one bonus tile. Returns nil if the size is invalid.
	/// - Parameters:
	///   - size: The dimension of the square board. Must be between 5 and 10 (inclusive).
	///   - treasure: The SF Symbol name for treasure icons (e.g., "suit.heart.fill").
	///   - hasBonus: Whether to include one special bonus tile. Defaults to false.
	/// - Returns: A configured Board instance, or nil if size is outside valid range.
	/// - Note: Automatically creates tiles and places treasures upon successful initialization.
	init?(size: Int, treasure: String, hasBonus: Bool = false) {
		guard (Board.minimumSize...Board.maximumSize).contains(size) else { return nil }
		
		self.size = size
		self.treasure = treasure
		self.hasBonus = hasBonus
		
		createTiles()
		placeTreasures()
		
		if hasBonus { placeBonusTile() }
	}
	
	// MARK: - Private Methods
	
	/// Creates an n x n grid of empty tiles.
	///
	/// Populates the tiles array with size x size Tile instances,
	/// all initialized to their default empty state.
	///
	/// - Note: Modifies the tiles property by appending rows of new Tile instances.
	private func createTiles() {
		for _ in 0..<size {
			var row: [Tile] = []
			for _ in 0..<size {
				row.append(Tile())
			}
			tiles.append(row)
		}
	}
	
	/// Randomly places treasures on 25% of the board's tiles.
	///
	/// Calculates the treasure count as (size * size * treasurePercentage), truncating to an integer.
	/// Uses random positioning to ensure treasures are distributed unpredictably.
	///
	/// - Note: Modifies tile contents by setting the treasure icon on selected tiles.
	private func placeTreasures() {
		let allPositions = generateShuffledPositions()
		let treasureCount = Int(Double(size * size) * Board.treasurePercentage)
		
		for i in 0..<treasureCount {
			let (row, col) = allPositions[i]
			tiles[row][col].contents = treasure
		}
	}
	
	/// Randomly places one bonus tile on an empty (non-treasure) tile.
	///
	/// Searches for the first available empty tile in a randomized order and marks it
	/// as the bonus tile with a special star icon. Does nothing if no empty tiles exist.
	///
	/// - Note: Modifies one tile's isBonus flag and contents property.
	private func placeBonusTile() {
		let allPositions = generateShuffledPositions()
		
		for (row, col) in allPositions {
			if tiles[row][col].contents == Board.emptyTileIcon {
				tiles[row][col].isBonus = true
				tiles[row][col].contents = Board.bonusTileIcon
				return
			}
		}
	}
	
	/// Generates all tile positions in random order.
	///
	/// Creates a complete list of (row, column) coordinates for every tile on the board,
	/// then shuffles them to provide random ordering for treasure and bonus placement.
	///
	/// - Returns: Array of (Int, Int) tuples representing shuffled (row, column) positions.
	private func generateShuffledPositions() -> [(Int, Int)] {
		var positions: [(Int, Int)] = []
		
		for row in 0..<size {
			for col in 0..<size {
				positions.append((row, col))
			}
		}
		
		return positions.shuffled()
	}
	
	/// Public Method
	/// Counts the number of unrevealed treasure tiles remaining on the board.
	///
	/// Iterates through all tiles to find those that contain treasures and have not
	/// yet been revealed by the player. Useful for tracking game progress.
	///
	/// - Returns: The count of treasure tiles that are still hidden (not revealed).
	func countUnrevealedTreasures() -> Int {
		var count = 0
		
		for row in tiles {
			for tile in row {
				if tile.contents == treasure && !tile.isRevealed { count += 1 }
			}
		}
		
		return count
	}
}
