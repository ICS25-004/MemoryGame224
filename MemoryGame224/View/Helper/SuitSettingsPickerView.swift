import SwiftUI

struct SuitSettingsPickerView: View {
	@Binding var suits: [Suit]
	@Binding var selectedSuitIndex: Int
	

	var body: some View {
		HStack(spacing: 0) {
			Button(action: {
				if selectedSuitIndex > 0 { selectedSuitIndex -= 1 }
			})
			{
				Image(systemName: "chevron.left")
			}
			.accessibilityIdentifier("SuitSettingsPickerView_LeftButton")
			.disabled(selectedSuitIndex == 0)
			
			Spacer()
			
			HStack(spacing: 12) {
				ForEach(suits.indices) {
					TabThumbnailView(
						currentIndex: $0,
						currentSuit: suits[$0],
						selectedSuitIndex: $selectedSuitIndex
					)
				}
			}
			.accessibilityIdentifier("SuitSettingsPickerView_ThumbnailScrollView")
			
			Spacer()
			
			Button(action: {
				if selectedSuitIndex < suits.count - 1 { selectedSuitIndex += 1 }
			})
			{
				Image(systemName: "chevron.right")
			}
			.accessibilityIdentifier("SuitSettingsPickerView_RightButton")
			.disabled(selectedSuitIndex >= max(suits.count - 1, 0))
			
		}
		.padding(.horizontal)
		.padding(.top, 24)
	}
}
