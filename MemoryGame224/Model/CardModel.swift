//
//  CardModel.swift
//  MemoryGame224
//
//  Created by Caleb on 2026-01-08.
//
import SwiftUI

enum Suit: String, CaseIterable {
	case heart, diamond, club, spade
	
	var color : Color {
		switch self {
		case .heart, .diamond: return .red
		case .club, .spade: return .black
		}
	}
	
	var iconName: String {
		switch self {
		case .heart: return "suit.heart.fill"
		case .diamond: return "suit.diamond.fill"
		case .club: return "suit.club.fill"
		case .spade: return "suit.spade.fill"
		}
	}
	
	var title: String {
			return self.rawValue.capitalized;
	}
}
