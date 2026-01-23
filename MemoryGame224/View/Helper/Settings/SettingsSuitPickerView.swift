import SwiftUI

struct SettingsSuitPickerView: View {
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
				ForEach(suits.indices, id: \.self) { index in
					SettingsTabThumbnailView(
						currentIndex: index,
						currentSuit: suits[index],
						selectedSuitIndex: $selectedSuitIndex
					)
				}
			}
			.accessibilityElement(children: .contain)
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
