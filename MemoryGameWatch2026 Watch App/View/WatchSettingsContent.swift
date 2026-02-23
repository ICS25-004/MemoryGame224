import SwiftUI

/// The settings content view optimized for watchOS.
///
/// Displays suit selector with chevron buttons and bonus toggle on black background.
struct WatchSettingsContent: View {
	/// The index of the currently selected suit in the suits array.
	@Binding var selectedSuitIndex: Int
	
	/// Whether the board includes a bonus tile, stored in UserDefaults.
	@Binding var hasBonusTile: Bool
	
	/// The currently selected suit for treasure icons.
	private var selectedSuit: Suit {
		let suits = Array(Suit.allCases)
		return suits[min(max(selectedSuitIndex, 0), suits.count - 1)]
	}
	
	var body: some View {
		VStack(spacing: 16) {
			// Suit selector with chevron buttons
			HStack(spacing: 12) {
				// Left chevron button
				Button {
					cycleSuit(direction: -1)
				} label: {
					Image(systemName: "arrowtriangle.left.fill")
						.font(.title3)
						.foregroundStyle(.white)
				}
				.buttonStyle(.plain)
				
				// Current suit icon with white background
				Image(systemName: selectedSuit.iconName)
					.font(.system(size: 40))
					.foregroundStyle(selectedSuit.color)
					.frame(width: 60, height: 60)
					.background(
						RoundedRectangle(cornerRadius: 8)
							.fill(.white)
					)
				
				// Right chevron button
				Button {
					cycleSuit(direction: 1)
				} label: {
					Image(systemName: "arrowtriangle.right.fill")
						.font(.title3)
						.foregroundStyle(.white)
				}
				.buttonStyle(.plain)
			}
			.padding(.top, 8)
			
			// Bonus toggle
			HStack {
				Text("Bonus")
					.font(.body)
				Spacer()
				Toggle("", isOn: $hasBonusTile)
					.labelsHidden()
					.tint(.green)
			}
			.padding(.horizontal, 8)
			
			Spacer()
		}
		.background(Color.black.ignoresSafeArea())
	}
	
	// MARK: - Private Methods
	
	/// Cycles to the next or previous suit in the available suits.
	///
	/// - Parameter direction: 1 for next suit, -1 for previous suit.
	private func cycleSuit(direction: Int) {
		let suits = Array(Suit.allCases)
		selectedSuitIndex = (selectedSuitIndex + direction + suits.count) % suits.count
	}
}

#Preview {
	WatchSettingsContent(
		selectedSuitIndex: .constant(0),
		hasBonusTile: .constant(false)
	)
}
