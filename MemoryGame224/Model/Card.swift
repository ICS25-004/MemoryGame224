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
    ///
    /// Hearts and diamonds are red, clubs and spades are black,
    /// following standard playing card conventions.
    var color: Color {
        switch self {
        case .heart, .diamond:
            return .red
        case .club, .spade:
            return .black
        }
    }
    
    /// The SF Symbol name for this suit's filled icon.
    ///
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
    
    /// The capitalized display name of the suit.
    ///
    /// - Returns: The suit name with the first letter capitalized (e.g., "Heart", "Club").
    var title: String {
        return self.rawValue.capitalized
    }
}
