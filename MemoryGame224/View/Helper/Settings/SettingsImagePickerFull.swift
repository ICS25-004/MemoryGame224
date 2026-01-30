import SwiftUI

struct SettingsImagePickerFull: View {
	@Binding var suits: [Suit]
	@Binding var selectedSuitIndex: Int
	
	
	var body: some View {
		HStack(spacing: 0) {
			Button(action: {
				if selectedSuitIndex > 0 { selectedSuitIndex -= 1 }
			})
			{
				Image(systemName: "chevron.left")
					.padding(15)
			}
			.glassEffect(.regular.tint(.orange).interactive(), in: Circle())
			.disabled(
				selectedSuitIndex == 0
			)
			.accessibilityIdentifier("SuitSettingsPickerView_LeftButton")
			
			Spacer()
			
			
			HStack(spacing: 10) {
				ForEach(suits.indices, id: \.self) { index in
					ImagePickerView(
						currentIndex: index,
						currentSuit: suits[index],
						selectedSuitIndex: $selectedSuitIndex
					)
				}
			}
			.accessibilityElement(children: .contain) //Issues without this, expliclty identify hstack to test all thumbnails
			.accessibilityIdentifier("SuitSettingsPickerView_ThumbnailScrollView")
			
			Spacer()
			
			Button(
				action: {
					if selectedSuitIndex < suits.count - 1 { selectedSuitIndex += 1 }
				}, label: {
					Image(systemName: "chevron.right")
						.padding(15)
				}
			)
			
			.glassEffect(.regular.tint(.orange).interactive(), in: Circle())
			.disabled(
				selectedSuitIndex >= max(suits.count - 1, 0)
			)
			.accessibilityIdentifier("SuitSettingsPickerView_RightButton")
		}
		.padding(.horizontal)
		.padding(.top, 24)
	}
}
