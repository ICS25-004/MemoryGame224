import SwiftUI

/// The root view of the application that manages navigation between game and settings screens.
///
/// Provides a navigation stack with a toolbar button to toggle between the game board and settings.
/// Manages shared state for suit selection and customization across screens.
struct ContentView: View {
	/// The index of the currently selected suit, persisted in UserDefaults.
	@AppStorage("selectedSuitIndex") private var suitIndex = 0
	
	/// Whether the settings screen is currently displayed.
	@State private var showingSettings = false
	
	var body: some View {
		NavigationStack {
			Group {
				if showingSettings {
					SettingsView(selectedSuitIndex: $suitIndex)
				} else {
					GameBoardView(selectedSuitIndex: $suitIndex)
				}
			}
			.toolbar {
				Button{
					showingSettings.toggle()
				} label: {
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
