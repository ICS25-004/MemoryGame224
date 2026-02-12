import SwiftUI

/// A tappable thumbnail view displaying a suit icon for selection.
///
/// Shows a suit icon in a rounded rectangle with a highlight border when selected.
/// Used within suit picker carousels to allow users to choose their preferred suit.
struct SuitThumbnail: View {
	/// The index of this suit in the suits array.
	let currentIndex: Int
	
	/// The suit to display in this thumbnail.
	let currentSuit: Suit
	
	/// The currently selected suit index.
	@Binding var selectedSuitIndex: Int
	
	var body: some View {
		Button(action: {
			selectedSuitIndex = currentIndex
		}) {
			VStack(spacing: 4) {
				Image(systemName: currentSuit.iconName)
					.frame(width: 44, height: 44)
					.foregroundStyle(currentSuit.color)
					.overlay(
						RoundedRectangle(cornerRadius: 8)
							.stroke(
								currentIndex == selectedSuitIndex ? Color.accentColor : Color.clear, lineWidth: 2
							)
					)
					.background(
						RoundedRectangle(cornerRadius: 8)
							.fill(Color.white)
					)
			}
		}
		.accessibilityAddTraits(.isButton)
		.accessibilityIdentifier("SuitThumbnail_Icon_\(currentSuit.rawValue)")
	}
}
