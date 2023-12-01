//
//  EmojiMemoryGameView.swift
//  View
//  Memorize
//
//  Created by Rob Ranf on 10/5/21.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @Namespace private var dealingNamespace
    @Environment(\.colorScheme) var colorScheme
    /**
     Initialize this in the MemorizeApp (@main) file by passing in the
     pointer to the vm as the viewModel. The vm is observed for changes
     so the view will re-render anytime the model is changed.
     */
    @ObservedObject var vmGame: EmojiMemoryGame
    @State private var dealt = Set<Int>()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Text("Memorize")
                    .font(.title)
                gameBody
                
                HStack {
                    restart
                    Spacer()
                    shuffle
                }
                .padding(.horizontal)
            }
            deckBody
        }
    }
    
    var gameBody : some View {
        AspectVGrid(items: vmGame.cards, aspectRatio: K.aspectRatio) { card in
            // Card has been thrown away because it's matched and not face up
            if notDealt(card) || card.isMatched && !card.isFaceUp {
                // Color behaves as a view here and creates a rectangle that fills this
                // "card" area and it's filled with "clear" which just means transparent.
                Color.clear
            } else {
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        // Choose is an intent function and calls to
                        // intent functions almost always include animations.
                        withAnimation(.easeInOut(duration: 1)) {
                            vmGame.choose(card)
                        }
                    }
            }
        }
        .foregroundColor(K.cardColor)
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(vmGame.cards.filter(notDealt)) {card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: K.undealtWidth, height: K.undealtHeight)
        .foregroundColor(K.cardColor)
        .onTapGesture {
            // "Deal" the cards into the UI. Remember, the cards (CardView) appear in the UI
            // with their containing view (AspectVGrid), they don't come in after that view has
            // loaded. So any animations for when the cards load need to be done on the enclosing
            // view (AspectVGrid).
            for card in vmGame.cards {
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
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
    
    var restart: some View {
        Button("Restart") {
            withAnimation {
                dealt = []
                vmGame.restart()
            }
        }
    }
    
    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    private func notDealt(_ card: EmojiMemoryGame.Card) -> Bool {
        return !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = vmGame.cards.firstIndex(where: { $0.id == card.id}) {
            delay = Double(index) * (K.totalDealDuration / Double(vmGame.cards.count))
        }
        return Animation.easeInOut(duration: K.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(vmGame.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
}

// MARK: - Preview pane

#Preview {
    let game = EmojiMemoryGame()
    game.choose(game.cards[0])
    game.choose(game.cards[2])
    return EmojiMemoryGameView(vmGame: game)
}
