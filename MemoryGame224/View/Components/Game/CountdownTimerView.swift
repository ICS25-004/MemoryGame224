import SwiftUI

/// Displays a countdown timer that transitions to a "Go!" message when complete.
///
/// Shows remaining seconds in large orange text during countdown, then displays
/// a green "Go!" message when the countdown finishes. Used for the memorization phase.
struct CountdownTimerView: View {
	/// Whether the countdown is currently active (treasures visible).
	let isCountingDown: Bool
	
	/// Number of seconds elapsed since countdown started.
	let elapsedTime: Int
	
	/// Duration of the countdown in seconds.
	let countdownDuration: Int
	
	var body: some View {
		Group {
			if isCountingDown {
				Text("\(max(0, countdownDuration - elapsedTime))")
					.foregroundStyle(.orange)
					.contentTransition(.numericText())
			} else {
				Text("Go!")
					.foregroundStyle(.green)
					
			}
		}
		.font(.system(size: 60, weight: .bold, design: .rounded))
		.padding(.top)
	}
}
