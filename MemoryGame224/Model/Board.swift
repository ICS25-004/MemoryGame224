//
//  Board.swift
//  MemoryGame224
//
//  Created by Caleb on 2026-01-29.
//

import Observation

@Observable class Board {
	let size: Int
	var tiles: [[Tile]] = [[Tile]]()
	let treasure: String
	
	init?(size: Int, treasure: String) {
		guard (5...10).contains(size) else { return nil }
		
		self.size = size
		self.treasure = treasure
		
		// Create all tiles
		for _ in 0..<size {
			var row = [Tile]()
			for _ in 0..<size {
				row.append(Tile())
			}
			self.tiles.append(row)
		}
		
		// Get all tile positions and shuffle them
		var allPositions = [(Int, Int)]()
		for row in 0..<size {
			for col in 0..<size {
				allPositions.append((row, col))
			}
		}
		allPositions.shuffle()
		
		// Set the first treasureTileCount positions to treasure
		for i in 0..<size * size / 4 {
			let (row, col) = allPositions[i]
			self.tiles[row][col].contents = treasure
		}
	}
}
