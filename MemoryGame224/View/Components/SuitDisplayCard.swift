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
		GeometryReader { geometry in
			ZStack {
				RoundedRectangle(cornerRadius: 10)
					.fill(.white)
					.shadow(radius: 7)
				Image(systemName: suit.iconName)
					.resizable()
					.scaledToFit()
					.frame(width: 100)
					.foregroundStyle(suit.color)
					.accessibilityIdentifier("SuitCardView_Image_\(suit.rawValue)")
					.padding(.top, 30)
					.padding(.horizontal, 20)
					.padding(.bottom, 25)
					.background(.white.opacity(0.2))
					.clipShape(RoundedRectangle(cornerRadius: 8))
			}
			.aspectRatio(2.5 / 4, contentMode: .fit)
			.frame(maxWidth: 400, maxHeight: 660)
			.padding(.horizontal, 40)
			.frame(width: geometry.size.width, height: geometry.size.height)
			.background(Color.accentColor)
		}
	}
}

