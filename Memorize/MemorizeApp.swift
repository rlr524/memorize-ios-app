//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Rob Ranf on 10/5/21.
//

import SwiftUI

@main
struct MemorizeApp: App {
    // Creating a pointer, named game, to the EmojiMemoryGame class, the ViewModel.
    // Can make this a constant because we're not going to change the pointer itself, we are only going to change the contents of what it points to, the vm
    private let game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
