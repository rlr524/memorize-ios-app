//
//  EmojiMemoryGameView.swift
//  View
//  Memorize
//
//  Created by Rob Ranf on 10/5/21.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @Environment(\.colorScheme) var colorScheme
    /**
     Initialize this in the MemorizeApp (@main) file by passing in the
     pointer to the vm as the viewModel. The vm is observed for changes
     so the view will re-render anytime the model is changed.
     */
    @ObservedObject var vmGame: EmojiMemoryGame
    @State private var dealt = Set<Int>()
    
    var body: some View {
        VStack {
            Text("Memorize")
                .font(.title)
            gameBody
            deckBody
            
            HStack {
                shuffle
            }
        }
        .padding()
    }
    
    var gameBody : some View {
        AspectVGrid(items: vmGame.cards, aspectRatio: 2/3) { card in
            // Card has been thrown away because it's matched and not face up
            if notDealt(card) || card.isMatched && !card.isFaceUp {
                // Color behaves as a view here and creates a rectangle that fills this
                // "card" area and it's filled with "clear" which just means transparent.
                Color.clear
            } else {
                CardView(card: card)
                    .padding(4)
                    .transition(AnyTransition.scale.animation(Animation.easeInOut(duration: 2)))
                    .onTapGesture {
                        // Choose is an intent function and calls to
                        // intent functions almost always include animations.
                        withAnimation(.easeInOut(duration: 1)) {
                            vmGame.choose(card)
                        }
                    }
            }
        }
        .onAppear {
            // "Deal" the cards into the UI. Remember, the cards (CardView) appear in the UI with
            // their containing view (AspectVGrid), they don't come in after that view has loaded. 
            // So any animations for when the cards load need to be done on the enclosing view
            // (AspectVGrid).
            withAnimation(.easeInOut(duration: 5)) {
                for card in vmGame.cards {
                    deal(card)
                }
            }
            
        }
        .foregroundColor(K.cardColor)
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(vmGame.cards.filter(notDealt)) {card in
                CardView(card: card)
            }
        }
        .frame(width: K.undealtWidth, height: K.undealtHeight)
        .foregroundColor(K.cardColor)
    }
    
    struct CardView: View {
        let card: EmojiMemoryGame.Card
        
        var body: some View {
            GeometryReader { g in
                ZStack {
                    TimerPie(
                        startAngle: Angle(degrees: 0-90),
                        endAngle: Angle(degrees: 110-90))
                    .padding(K.timerCirclePadding)
                    .opacity(K.timerCircleOpacity)
                    Text(card.content)
                        .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                        .animation(.linear(duration: 1).repeatForever(autoreverses: false), 
                                   value: card.isMatched)
                        .font(Font.system(size: K.fontSize))
                        .scaleEffect(scale(thatFits: g.size))
                }
                .cardify(isFaceUp: card.isFaceUp)
            }
        }
        
        private func scale(thatFits size: CGSize) -> CGFloat {
            min(size.width, size.height) / (K.fontSize / K.fontScale)
        }
    }
    
    var shuffle: some View {
        Button("Shuffle") {
            // Shuffle is an intent function and calls to intent
            // functions almost always include animations.
            withAnimation(.easeInOut(duration: 2)) {
                vmGame.shuffle()
            }
        }
    }
    
    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    private func notDealt(_ card: EmojiMemoryGame.Card) -> Bool {
        return !dealt.contains(card.id)
    }
}

// MARK: - Preview pane

#Preview {
    let game = EmojiMemoryGame()
    game.choose(game.cards[0])
    game.choose(game.cards[2])
    return EmojiMemoryGameView(vmGame: game)
}
