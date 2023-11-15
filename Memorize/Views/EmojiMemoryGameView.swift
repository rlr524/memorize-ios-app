//
//  EmojiMemoryGameView.swift
//  View
//  Memorize
//
//  Created by Rob Ranf on 10/5/21.
//

/*
 https://youtu.be/-N1UR7Y105g?si=fGXY9z9DlsX36ORh&t=488
 */

import SwiftUI

struct EmojiMemoryGameView: View {
    @Environment(\.colorScheme) var colorScheme
    /*
     Initialize this in the MemorizeApp (@main) file by passing in the
     pointer to the vm as the viewModel. The vm is observed for changes
     so the view will re-render anytime the model is changed.
     */
    
    @ObservedObject var game: EmojiMemoryGame
    
    var body: some View {
        VStack {
            Text("Memorize")
                .font(.title)
            gameBody
            
            HStack {
                shuffle
            }
        }
        .padding()
    }
    
    var gameBody : some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            // Card has been thrown away because it's matched and not face up
            if card.isMatched && !card.isFaceUp {
                // Color behaves as a view here and creates a rectangle that fills this
                // "card" area and it's filled with "clear" which just means transparent.
                Color.clear
            } else {
                CardView(card: card)
                    .padding(4)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 1)) {
                            game.choose(card)
                        }
                    }
            }
        }
        .foregroundColor(.red)
    }
    
    var shuffle: some View {
        Button("Shuffle") {
            withAnimation(.easeInOut(duration: 2)) {
                game.shuffle()
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
}

// MARK: - Preview pane
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards[0])
        game.choose(game.cards[2])
        // game.choose(game.cards[4])
        return EmojiMemoryGameView(game: game)
    }
}
