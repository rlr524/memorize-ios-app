//
//  AspectVGrid.swift
//  Memorize
//
//  Created by Rob Ranf on 6/25/22.
//

import SwiftUI

struct AspectVGrid<Item, ItemView>: View where ItemView: View, Item: Identifiable {
    var items: [Item]
    var aspectRatio: CGFloat
    var content: (Item) -> ItemView

    /// Why use @escaping on the content parameter? The closure expression it is passed as a value, (Item) -> ItemView "escapes"
    /// from the context of this init. It is assigned above as the content var and then used below in the body declaration as "content".
    /// This is only an issue with closures. The @escaping attribute tells the compiler it's ok that this closure is executed inline, no
    /// memory needs to be created (since closures are function types and therefore passed by reference). If the closure isn't
    /// escaping, the compiler would otherwise create memory which isn't necessary. The var "content" above is pointing to the
    /// (Item) -> ItemView function it is passed as a value and memory is created. That isn't needed in this case. *FROM Swift Docs:
    /// A closure is said to escape a function when the closure is passed as an argument to the function, but is called after the
    /// function returns. When you declare a function that takes a closure as one of its parameters, you can write @escaping before
    /// the parameter’s type to indicate that the closure is allowed to escape. One way that a closure can escape is by being stored
    /// in a variable that’s defined outside the function. As an example, many functions that start an asynchronous operation take a
    /// closure argument as a completion handler. The function returns after it starts the operation, but the closure isn’t called until
    /// the operation is completed—the closure needs to escape, to be called later.*
    init(items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
            let width: CGFloat = widthThatFits(itemCount: items.count, in: geometry.size, itemAspectRatio: aspectRatio)
            LazyVGrid(columns: [adaptiveGridItem(width: width)], spacing: 0.0) {
                ForEach(items) { item in
                    content(item).aspectRatio(aspectRatio, contentMode: .fit)
                }
            }
                Spacer(minLength: 0)
            }
        }
    }

    private func adaptiveGridItem(width: CGFloat) -> GridItem {
        var gridItem = GridItem(.adaptive(minimum: width))
        gridItem.spacing = 0
        return gridItem
    }

    private func widthThatFits(itemCount: Int, in size: CGSize, itemAspectRatio: CGFloat) -> CGFloat {
        var columnCount = 1
        var rowCount = itemCount
        repeat {
            let itemWidth = size.width / CGFloat(columnCount)
            let itemHeight = itemWidth / itemAspectRatio
            if CGFloat(rowCount) * itemHeight < size.height {
                break
            }
            columnCount += 1
            rowCount = (itemCount + (columnCount - 1)) / columnCount
        } while columnCount < itemCount
        if columnCount > itemCount {
            columnCount = itemCount
        }
        return floor(size.width / CGFloat(columnCount))
    }
}

//struct AspectVGrid_Previews: PreviewProvider {
//    static var previews: some View {
//        AspectVGrid()
//    }
//}
