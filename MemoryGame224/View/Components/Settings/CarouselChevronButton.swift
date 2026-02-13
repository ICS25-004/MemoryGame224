import SwiftUI

/// A navigation button for the suit carousel that supports infinite looping.
///
/// Displays a chevron icon (left or right) and cycles through items with wraparound.
/// When reaching the end of the list, continues from the beginning, and vice versa.
struct CarouselChevronButton: View {
	/// Direction of navigation for the chevron button.
	enum Direction {
		case left
		case right
		
		/// The SF Symbol name for the chevron icon.
		var iconName: String {
			switch self {
			case .left: return "chevron.left"
			case .right: return "chevron.right"
			}
		}
		
		/// The accessibility identifier suffix for the button.
		var accessibilityId: String {
			switch self {
			case .left: return "LeftButton"
			case .right: return "RightButton"
			}
		}
	}
	
	/// The direction this button navigates.
	let direction: Direction
	
	/// The currently selected index in the carousel.
	@Binding var selectedIndex: Int
	
	/// The total number of items in the carousel.
	let totalCount: Int
	
	var body: some View {
		Button(action: handleTap) {
			Image(systemName: direction.iconName)
				.padding(15)
		}
		.glassEffect(.regular.tint(.orange).interactive(), in: Circle())
		.accessibilityIdentifier("SuitCarousel_\(direction.accessibilityId)")
	}
	
	/// Handles the button tap with infinite looping logic.
	///
	/// For left navigation: wraps from 0 to the last index.
	/// For right navigation: wraps from the last index to 0.
	private func handleTap() {
		switch direction {
		case .left:
			selectedIndex = selectedIndex > 0 ? selectedIndex - 1 : totalCount - 1
		case .right:
			selectedIndex = selectedIndex < totalCount - 1 ? selectedIndex + 1 : 0
		}
	}
}
