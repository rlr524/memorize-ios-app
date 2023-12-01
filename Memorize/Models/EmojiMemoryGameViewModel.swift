//
//  EmojiMemoryGame.swift
//  ViewModel
//  Memorize
//
//  Created by Rob Ranf on 10/22/21.
//

import Foundation

class EmojiMemoryGame: ObservableObject {
    private static var gameType = K.gameType
    typealias Card = MemoryGame<String>.Card
    /*
    We make this a type variable (static) in order to allow it to act as a global var but
    bind it to a specific namespace. In this case, we need our emojis variable to be
    initialized in a global context in order to allow it to be returned by the model.
    */
    private static let emojis = [
        "🎃", "🍫", "🍬", "💀", "👻", "🧛🏻‍♀️", "🧙‍♀️", "🧙", "🌕", 
        "🧛‍♂️", "🐈‍⬛", "🦇", "😱", "🧟‍♀️", "🧟‍♂️"]
    private static let holidayEmojis = [
        "🎁", "🎄", "🎅", "🎎", "🪔", "🤶🏽", "🧑🏼‍🎄", "🦃", "🎂", 
        "❄️", "☃️", "⛄️", "🛷", "🙏", "🎉", "🎊", "🥳", "🍁",
        "🥮", "🥧"]
    private static let flagEmojis = [
        "🇺🇳", "🇺🇸", "🇯🇵", "🇨🇳", "🇨🇦", "🇬🇧", "🇨🇭", "🇬🇷", "🇩🇪", 
        "🇫🇷", "🇦🇷", "🇳🇱", "🇳🇬", "🇮🇩", "🇷🇺", "🇰🇷", "🇸🇪", "🇮🇹",
        "🇦🇺", "🇲🇿"]
    
    /**
    This is a type function (static) in order to allow it to act as a global func but bind to
    a specific namespace.
    */
    private static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: K.numberOfPairsOfCards,
                           createCardContent: {pairIndex in
            if (gameType == "flag") {
                return flagEmojis[pairIndex]
            }
            else if (gameType == "halloween") {
                return emojis[pairIndex]
            } else {
                return holidayEmojis[pairIndex]
            }
        })
    }

    /**
    The model is access controlled, private, as we only want the EmojiMemoryGame ViewModel to
    have full access to it. The model is also published, allowing the view to be re-rendered
    anytime that anything in the model is changed.
    */
    @Published private var model = createMemoryGame()

    /**
    Even though the model is private, we need the cards to be readable by other views,
    so we create an array of cards here for the VM and all it does is return the array of card
    from the model.
    */
    var cards: [Card] {
        return model.cards
    }
    
    // MARK: Intent(s)
    
    func choose(_ card: Card) {
        // Have the model do the choosing, overriding the choose()
        // method on the MemoryGame model. 
        model.choose(card)
    }
    
    func shuffle() {
        // Have the model do the shuffling, overriding the shuffle()
        // method on the MemoryGame model.
        model.shuffle()
    }
    
    func restart() {
        model = EmojiMemoryGame.createMemoryGame()
    }
}
