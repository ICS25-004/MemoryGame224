//
//  Board.swift
//  MemoryGame224
//
//  Created by Caleb on 2026-01-29.
//

import Observation

/// Represents the game board containing a grid of tiles.
@Observable class Board {
    /// The size of the board (n x n).
    let size: Int
    
    /// 2D array of tiles representing the game board.
    var tiles: [[Tile]] = []
    
    /// The treasure icon to use (system image name).
    let treasure: String
    
    /// Whether the board has a bonus tile.
    let hasBonus: Bool
    
    /// Initializes a new board with the specified size and treasure.
    /// - Parameters:
    ///   - size: The size of the board (must be in range 5...10).
    ///   - treasure: The system image name for the treasure icon.
    ///   - hasBonus: Whether to include a bonus tile on the board.
    init?(size: Int, treasure: String, hasBonus: Bool = false) {
        guard (5...10).contains(size) else { return nil }
        
        self.size = size
        self.treasure = treasure
        self.hasBonus = hasBonus
        
        createTiles()
        placeTreasures()
        
        if hasBonus {
            placeBonusTile()
        }
    }
    
    // MARK: - Private Methods
    
    /// Creates an n x n grid of empty tiles.
    private func createTiles() {
        for _ in 0..<size {
            var row: [Tile] = []
            for _ in 0..<size {
                row.append(Tile())
            }
            tiles.append(row)
        }
    }
    
    /// Places treasures randomly on 25% of the tiles (truncated to integer).
    private func placeTreasures() {
        let allPositions = generateShuffledPositions()
        let treasureCount = size * size / 4
        
        for i in 0..<treasureCount {
            let (row, col) = allPositions[i]
            tiles[row][col].contents = treasure
        }
    }
    
    /// Places a bonus tile randomly on an empty tile.
    private func placeBonusTile() {
        let allPositions = generateShuffledPositions()
        
        for (row, col) in allPositions {
            if tiles[row][col].contents == "circle.dotted" {
                tiles[row][col].isBonus = true
                tiles[row][col].contents = "star.hexagon.fill"
                return
            }
        }
    }
    
    /// Generates all tile positions and returns them in shuffled order.
    /// - Returns: Array of shuffled (row, col) tuples.
    private func generateShuffledPositions() -> [(Int, Int)] {
        var positions: [(Int, Int)] = []
        
        for row in 0..<size {
            for col in 0..<size {
                positions.append((row, col))
            }
        }
        
        return positions.shuffled()
    }
    
    // MARK: - Public Methods
    
    /// Counts the number of unrevealed treasure tiles.
    /// - Returns: The count of treasures that have not been revealed.
    func countUnrevealedTreasures() -> Int {
        var count = 0
        
        for row in tiles {
            for tile in row {
                if tile.contents == treasure && !tile.isRevealed {
                    count += 1
                }
            }
        }
        
        return count
    }
}
