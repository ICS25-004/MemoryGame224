import SwiftUI

/// Represents a playing card suit used for treasure icons in the memory game.
///
/// Provides standard playing card suits with associated colors and SF Symbol icon names.
/// Each suit can be uniquely identified and encoded for persistence.
enum Suit: String, CaseIterable, Identifiable, Equatable, Codable {
	/// Unique identifier for the suit, derived from its raw value.
	var id: String { rawValue }
	
	case heart, club, diamond, spade
	
	/// The color associated with this suit.
	/// Hearts and diamonds are red, clubs and spades are black.
	var color: Color {
		switch self {
			case .heart, .diamond:
				return .red
			case .club, .spade:
				return .black
		}
	}
	
	/// - Returns: The system image name string for displaying the suit icon.
	var iconName: String {
		switch self {
			case .heart:
				return "suit.heart.fill"
			case .diamond:
				return "suit.diamond.fill"
			case .club:
				return "suit.club.fill"
			case .spade:
				return "suit.spade.fill"
		}
	}
	
	/// - Returns: The suit name with the first letter capitalized (e.g., "Heart", "Club").
	var title: String {
		 self.rawValue.capitalized
	}
	
	// MARK: - Bonus Tile Configuration
	
	/// The SF Symbol name for bonus tiles.
	static let bonusIconName = "theatermasks.fill"
	
	/// The color for bonus tiles (light purple).
	static let bonusColor = Color(red: 0.7, green: 0.5, blue: 0.9)
}
