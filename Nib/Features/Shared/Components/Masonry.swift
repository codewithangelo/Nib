//
//  Masonry.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-10.
//

import SwiftUI

struct Masonry<T1: Identifiable & Equatable, T2: View>: View {
    struct Column: Identifiable {
        let id = UUID()
        var gridItems = [T1]()
    }
    
    @Binding
    var gridItems: [T1]
    var numberOfColumns: Int
    var itemContent: (T1) -> T2
    var loadMore: () -> Void
    var getHeight: (T1) -> CGFloat
    var spacing: CGFloat
    var horizontalPadding: CGFloat
    
    let columns: [Column]
    
    init(
        gridItems: Binding<[T1]>,
        numOfColumns: Int,
        @ViewBuilder itemContent: @escaping (T1) -> T2,
        loadMore: @escaping () -> Void,
        getHeight: @escaping (T1) -> CGFloat,
        spacing: CGFloat = 10,
        horizontalPadding: CGFloat = 10
    ) {
        self._gridItems = gridItems
        self.numberOfColumns = 2
        self.itemContent = itemContent
        self.loadMore = loadMore
        self.getHeight = getHeight
        self.spacing = spacing
        self.horizontalPadding = horizontalPadding
        
        var columns = [Column]()
        
        for _ in 0 ..< numOfColumns {
            columns.append(Column())
        }
        
        var columnsHeight = Array<CGFloat>(repeating: 0, count: numOfColumns)
        
        for gridItem in gridItems {
            var smallestColumnIndex = 0
            var smallestHeight = columnsHeight.first!
            
            for i in 1 ..< columnsHeight.count {
                let currentHeight = columnsHeight[i]
                if currentHeight < smallestHeight {
                    smallestHeight = currentHeight
                    smallestColumnIndex = i
                }
            }
            columns[smallestColumnIndex].gridItems.append(gridItem.wrappedValue)
            columnsHeight[smallestColumnIndex] += getHeight(gridItem.wrappedValue)
        }
        
        self.columns = columns
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: spacing) {
            ForEach(columns) { column in
                LazyVStack(spacing: spacing) {
                    ForEach(column.gridItems) { gridItem in
                        itemContent(gridItem)
                            .onAppear {
                                if gridItem == gridItems.last {
                                    loadMore()
                                }
                            }
                    }
                }
            }
        }
        .padding(.horizontal, horizontalPadding)
    }
}

#Preview {
    ScrollView {
        Masonry(
            gridItems: .constant([
                Poem(authorId: "1", content: "Lorem ipsum", id: "1", title: "1"),
                Poem(authorId: "2", content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", id: "2", title: "2"),
                Poem(authorId: "3", content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", id: "3", title: "3")
            ]),
            numOfColumns: 2,
            itemContent: { poem in
                Card(title: poem.title, content: poem.content)
                    .frame(minHeight: 100, idealHeight: CGFloat(poem.content.count + 100), maxHeight: 500)
            },
            loadMore: { },
            getHeight: { poem in
                CGFloat(poem.content.count + 100)
            }
        )
    }
}
