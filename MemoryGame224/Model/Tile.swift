//
//  Tile.swift
//  MemoryGame224
//
//  Created by Caleb on 2026-01-29.
//

import Observation

/// Represents a single tile in the memory game board.
@Observable class Tile: Identifiable {
    /// The content displayed on the tile (system image name).
    var contents: String = "circle.dotted"
    
    /// Whether the tile has been revealed by the user.
    var isRevealed: Bool = false
    
    /// Whether this tile is the bonus tile.
    var isBonus: Bool = false
    
    /// Whether the bonus tile has been used (bonus can only be used once).
    var bonusUsed: Bool = false
}

