import SwiftUI

struct TabButtonsView: View {
		@Binding var selection: Int
		let lowerBound: Int
		let upperBound: Int

		var body: some View {
				HStack {
						Button {
								selection = max(selection - 1, lowerBound)
						} label: {
								Image(systemName: "chevron.left")
										.font(.title2.bold())
										.padding()
										.background(.ultraThinMaterial, in: Circle())
						}
						.accessibilityIdentifier("TabButtonsView_LeftButton")
						.disabled(selection == lowerBound)
						.opacity(selection == lowerBound ? 0.5 : 1)

						Spacer()

						Button {
								selection = min(selection + 1, upperBound)
						} label: {
								Image(systemName: "chevron.right")
										.font(.title2.bold())
										.padding()
										.background(.ultraThinMaterial, in: Circle())
						}
						.accessibilityIdentifier("TabButtonsView_RightButton")
						.disabled(selection == upperBound)
						.opacity(selection == upperBound ? 0.5 : 1)
				}
		}
}
