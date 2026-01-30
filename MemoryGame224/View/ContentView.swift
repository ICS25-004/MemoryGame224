import SwiftUI

struct ContentView: View {
	@AppStorage("selectedSuitIndex") private var selectedSuitIndex = 0

	@AppStorage("showingSettings") private var showingSettings = false
	@State private var suits: [Suit] = Array(Suit.allCases)


	var body: some View {
		NavigationStack {
			Group {
				if showingSettings {
					SettingsView(
						selectedSuitIndex: $selectedSuitIndex,
						suits: $suits
					)
				} else {
					GameView(
						selectedSuitIndex: $selectedSuitIndex,
						suits: $suits
					)
				}
			}
			.toolbar {
				Button(action: { showingSettings.toggle() }) {
					Image(systemName: showingSettings ? "house.fill" : "gearshape.fill")
						.accessibilityIdentifier("ContentView_ToggleSettingsButtonIcon")
				}
				.buttonStyle(.glassProminent)
				.accessibilityIdentifier("ContentView_ToggleSettingsButton")
			}
		}
	}
}

#Preview {
	ContentView()
}
