import SwiftUI

struct SuitPickerView: View {
	@Binding var suits: [Suit]
	@Binding var selectedSuitIndex: Int
	

	var body: some View {
		HStack(spacing: 16) {
			Button(action: {
				if selectedSuitIndex > 0 { selectedSuitIndex -= 1 }
			})
			{
				Image(systemName: "chevron.left")
			}
			.accessibilityIdentifier("SuitPickerView_LeftButton")
			.disabled(selectedSuitIndex == 0)
			
			
			Spacer(minLength: 0)
			
			ScrollView(.horizontal, showsIndicators: false) {
				HStack(spacing: 12) {
					ForEach(suits.indices) {
						ThumbnailView(
							currentIndex: $0,
							currentSuit: suits[$0],
							selectedSuitIndex: $selectedSuitIndex
						)
					}
				}
			}
			.accessibilityIdentifier("SuitPickerView_ThumbnailScrollView")
			.frame(height: 70)
			
			
			Spacer(minLength: 0)
			
			Button(action: {
				if selectedSuitIndex < suits.count - 1 { selectedSuitIndex += 1 }
			})
			{
				Image(systemName: "chevron.right")
			}
			.accessibilityIdentifier("SuitPickerView_RightButton")
			.disabled(selectedSuitIndex >= max(suits.count - 1, 0))
			
		}
		.padding(.horizontal)
	}
}
