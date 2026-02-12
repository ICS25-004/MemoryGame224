import SwiftUI

/// A horizontal carousel for selecting suits with navigation chevrons and thumbnails.
///
/// Displays all available suits as thumbnails with left/right navigation buttons.
/// Users can tap thumbnails directly or use chevron buttons to cycle through options.
/// Tapping allows for infinite looping of suits... Swiping does not.
struct SuitCarousel: View {
	/// The currently selected suit index.
	@Binding var selectedSuitIndex: Int
	
	/// The array of available suits to display.
	private let suits = Array(Suit.allCases)
	
	var body: some View {
		HStack(spacing: 0) {
			Button(
				action: {
					if selectedSuitIndex > 0 { selectedSuitIndex -= 1 }
			}) {
				Image(systemName: "chevron.left")
					.padding(15)
			}
			.glassEffect(.regular.tint(.orange).interactive(), in: Circle())
			.disabled(selectedSuitIndex == 0)
			.accessibilityIdentifier("SuitCarousel_LeftButton")
			
			Spacer()
			
			HStack(spacing: 10) {
				ForEach(suits.indices, id: \.self) {
					SuitThumbnail(
						currentIndex: $0,
						currentSuit: suits[$0],
						selectedSuitIndex: $selectedSuitIndex
					)
				}
			}
			.accessibilityElement(children: .contain)
			.accessibilityIdentifier("SuitCarousel_ThumbnailContainer")
			
			Spacer()
			
			Button(
				action: {
					if selectedSuitIndex < suits.count - 1 {
						selectedSuitIndex += 1
					}
				},
				label: {
					Image(systemName: "chevron.right")
						.padding(15)
				}
			)
			.glassEffect(.regular.tint(.orange).interactive(), in: Circle())
			.disabled(selectedSuitIndex >= max(suits.count - 1, 0))
			.accessibilityIdentifier("SuitCarousel_RightButton")
		}
		.padding(.horizontal)
		.padding(.top, 24)
	}
}
