import SwiftUI

/// A horizontal carousel for selecting suits with navigation chevrons and thumbnails.
///
/// Displays all available suits as thumbnails with left/right navigation buttons.
/// Users can tap thumbnails directly or use chevron buttons to cycle through options.
/// Chevron buttons support infinite looping, wrapping from the last suit to the first and vice versa.
struct SuitCarousel: View {
	/// The currently selected suit index.
	@Binding var selectedSuitIndex: Int
	
	/// The array of available suits to display.
	private let suits = Array(Suit.allCases)
	
	var body: some View {
		HStack(spacing: 0) {
			CarouselChevronButton(
				direction: .left,
				selectedIndex: $selectedSuitIndex,
				totalCount: suits.count
			)
			
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
			
			CarouselChevronButton(
				direction: .right,
				selectedIndex: $selectedSuitIndex,
				totalCount: suits.count
			)
		}
		.padding(.horizontal)
		.padding(.top, 24)
	}
}
