import SwiftUI

/// Displays game statistics in a styled footer bar.
///
/// Shows the current tap count and remaining treasure count in capsule-shaped
/// containers with glass effect styling.
struct GameStatsFooter: View {
    /// The number of tiles tapped by the player.
    let tapCount: Int
    
    /// The number of unrevealed treasures remaining on the board.
    let treasureCount: Int
    
    var body: some View {
        HStack {
            Group {
                Text("Tap Count: \(tapCount)")
                Text("Treasure Count: \(treasureCount)")
            }
            .padding()
            .background(Color.accentColor, in: Capsule())
            .glassEffect()
        }
    }
}
