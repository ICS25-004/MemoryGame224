import SwiftUI

/// Displays a countdown timer that transitions to a "Go!" message when complete.
///
/// Shows remaining seconds in large orange text during countdown, then displays
/// a green "Go!" message when the countdown finishes. Used for the memorization phase.
struct CountdownTimerView: View {
    /// Duration of the countdown in seconds.
    private static let countdownDuration = 4
    
    /// Whether the countdown is currently active (treasures visible).
    let isCountingDown: Bool
    
    /// Number of seconds elapsed since countdown started.
    let elapsedTime: Int
    
    var body: some View {
        if isCountingDown {
            Text("\(max(0, CountdownTimerView.countdownDuration - elapsedTime))")
                .font(.system(size: 60, weight: .bold, design: .rounded))
                .foregroundStyle(.orange)
                .contentTransition(.numericText())
                .padding(.top)
        } else {
            Text("Go!")
                .font(.system(size: 60, weight: .bold, design: .rounded))
                .foregroundStyle(.green)
                .padding(.top)
        }
    }
}
