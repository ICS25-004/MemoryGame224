//
//  ContentView.swift
//  MemoryGame226
//
//  Created by Caleb on 2026-01-05.
//

import SwiftUI

struct ContentView: View {
    let suits: [String] = ["heart", "suit.spade", "suit.club", "diamonds"]
    @State private var activeSuit = 2
    var body: some View {
        VStack {
            HStack{
                Image(systemName: "arrowtriangle.left")
                    .resizable()
                    .foregroundStyle(.tint)
                    .aspectRatio(contentMode: .fit)
                    .onTapGesture {
                        activeSuit = (activeSuit - 1 + suits.count) % suits.count
                    }
                VStack {
                    Image(systemName: suits[activeSuit])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .imageScale(.large)
                        .foregroundStyle(.black)
                        
                    Text(suits[activeSuit].capitalized)
                }
                Image(systemName: "arrowtriangle.right")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.tint)
                    .onTapGesture {
                        activeSuit = (activeSuit + 1) % suits.count
                    }
                    
                    
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

