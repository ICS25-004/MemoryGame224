import SwiftUI

/// The root view of the application.
///
/// Displays the game board on iOS and a tabbed interface on watchOS.
/// Settings are accessed via the iOS Settings app on iPhone.
struct ContentView: View {
	/// The index of the currently selected suit, persisted in UserDefaults.
	@AppStorage("selectedSuitIndex") private var suitIndex = 0
	
	var body: some View {
		#if os(watchOS)
		// watchOS: Vertical TabView for swipe navigation
		TabView {
			GameBoardView(selectedSuitIndex: $suitIndex)
			
			SettingsView(selectedSuitIndex: $suitIndex)
		}
		.tabViewStyle(.verticalPage)
		#else
		// iOS: Game board only (settings via Settings.app)
		GameBoardView(selectedSuitIndex: $suitIndex)
		#endif
	}
}

#Preview {
	ContentView()
}
