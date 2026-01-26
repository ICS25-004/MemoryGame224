import SwiftUI

struct GameTabButtonsView: View {
		@Binding var selection: Int
		let lowerBound: Int
		let upperBound: Int

		var body: some View {
				HStack {
						Button {
								// Wrap around: if at first item, go to last
								if selection == lowerBound {
										selection = upperBound
								} else {
										selection = selection - 1
								}
						} label: {
								Image(systemName: "chevron.left")
										.font(.title2.bold())
										.padding()
										.background(.ultraThinMaterial, in: Circle())
						}
						.accessibilityIdentifier("TabButtonsView_LeftButton")
					
						Spacer()

						Button {
								// Wrap around: if at last item, go to first
								if selection == upperBound {
										selection = lowerBound
								} else {
										selection = selection + 1
								}
						} label: {
								Image(systemName: "chevron.right")
										.font(.title2.bold())
										.padding()
										.background(.ultraThinMaterial, in: Circle())
						}
						.accessibilityIdentifier("TabButtonsView_RightButton")
				}
		}
}
