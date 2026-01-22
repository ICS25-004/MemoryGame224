//
//  SuitCardView.swift
//  MemoryGame224
//
//  Created by Caleb on 2026-01-12.
//

import SwiftUI

struct SuitCardView: View {
	@Binding var suit: Suit
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 10)
				.foregroundStyle(Color.white)
				.shadow(radius: 7)
			
			VStack {
				Image(systemName: suit.iconName)
					.resizable()
					.scaledToFit()
					.frame(width: 100)
					.foregroundColor(suit.color)
					.padding(.bottom, 25)
			}
			.padding(.top, 30)
			.padding(.horizontal, 20)
			.background(Color.white.opacity(0.2))
			.clipShape(RoundedRectangle(cornerRadius: 8))
		}
		.padding(35)
		.background(Color.accentColor)
	}
}

