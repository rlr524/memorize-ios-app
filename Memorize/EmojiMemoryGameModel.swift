//
//  EmojiMemoryGame.swift
//  ViewModel
//  Memorize
//
//  Created by Rob Ranf on 10/22/21.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    /// We make this a type variable (static) in order to allow it to act as a global var but bind it to a specific namespace
    /// In this case, we need our emojis variable to be initialized in a global context in order to allow it to be returned by the model
    private static let emojis = ["🎃", "🍫", "🍬", "💀", "👻", "🧛🏻‍♀️", "🧙‍♀️", "🧙","🍂", "🌙", "🧛‍♂️", "🐈‍⬛", "🏠", "🦇", "🌃", "🔦", "🔮", "😱", "🧟‍♀️", "🧟‍♂️", "🎁", "🎄", "🎅", "🎎", "🪔", "🤶🏽", "🧑🏼‍🎄", "🦃", "🎂", "❄️", "☃️", "⛄️", "🛷", "🙏", "🎉", "🎊", "🥳", "🍁", "🥮", "🥧", "🇺🇳", "🇺🇸", "🇯🇵", "🇨🇳", "🇨🇦", "🇬🇧", "🇨🇭", "🇬🇷", "🇩🇪", "🇫🇷", "🇦🇷", "🇳🇱", "🇳🇬", "🇮🇩", "🇷🇺", "🇰🇷", "🇸🇪", "🇮🇹", "🇦🇺", "🇲🇿"]
    
    
//    var emojiTheme = 0
//    var emojiCount = 20
    
    /// This is a type function (static) in order to allow it to act as a global func but bind to a specific namespace
    private static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 10, createCardContent: {pairIndex in
            return emojis[pairIndex]
        })
    }
    
    /// The model is access controlled, private, as we only want the EmojiMemoryGame ViewModel to have full access to it
    /// The model is also published, allowing the view to be re-rendered anytime that anything in the model is changed
    @Published private var model = createMemoryGame()
    
    /// Even though the model is private, we need the cards to be readable by other views, so we create an array of cards here for the VM and all it does is return the array of cards from the model
    var cards: Array<Card> {
        return model.cards
    }
    
    //MARK: - Intent(s)
    func choose(_ card: Card) {
        model.choose(card)
    }
}
