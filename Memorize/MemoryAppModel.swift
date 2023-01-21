//
//  MemoryGame.swift
//  Model
//  Memorize
//
//  Created by Rob Ranf on 10/22/21.
//

import Foundation

/*
 While we don't care about the CardContent type, so it's a generic, we do
 need it to behave like an equatable in order to be able to match the content
 of cards in the game logic. We do this with the where statement and having
 CardContent conform to the Equatable protocol.
 */

// Contains all business logic for the game
// Create the struct with the generic type CardContent to allow for the
// content to be changed to an image or something else in the future
struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: [Card]

    private var indexOfTheOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter({ cards[$0].isFaceUp }).oneAndOnly
        }
        set { cards.indices.forEach { cards[$0].isFaceUp = ($0 == newValue)}
            // cards.indices is the same as 0..<cards.count
        }
    }

    mutating func choose(_ card: Card) {
        /*
         Using an if let here to only unwrap our index return value (firstIndex
         returns an optional Int) if there is a value there, otherwise return
         nil.
         
         Use a comma to separate the three statements in the if let acts the
         same as a logical "and"...cannot use an && in an if let statement; the
         if let needs to be evaluated before the statements after the comma
         and with an && all statements are evaluated together; the comma
         allows them to be evaluated in sequence but evaluated in the context
         that all statements must be true.
         */
        // The $0.id refers to the id of the element that is the firstIndex,
        // so to the first card in the "cards" array
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfTheOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOnlyFaceUpCard = chosenIndex
            }
        }
    }

    // An initializer is needed here because we want to use this struct
    // as the initializer for our VM where we pass in the number of
    // pairs of cards
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = []
        // add numberOfPairsOfCards x 2 to cards array
        for pairIndex in 0..<numberOfPairsOfCards {
            let cardContent = createCardContent(pairIndex)
            cards.append(Card(content: cardContent, id: pairIndex * 2))
            cards.append(Card(content: cardContent, id: pairIndex * 2 + 1))
        }
    }

    /// Namespacing the card in MemoryGame in order to allow for other types of "cards" in the future
    struct Card: Identifiable {
        var isFaceUp = false
        var isMatched = false
        let content: CardContent
        let id: Int
    }
}
