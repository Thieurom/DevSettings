//
//  IndexedForEach.swift
//  DevSettings
//
//  Created by Doan Thieu on 30/3/25.
//

import SwiftUI

struct IndexedForEach<Data, Content>: View where Data: RandomAccessCollection, Data.Index: Hashable, Content: View {

    let data: Data
    let content: (Data.Index, Data.Element) -> Content

    var body: some View {
        ForEach(Array(zip(data.indices, data)), id: \.0) { index, element in
            content(index, element)
        }
    }

    init(
        _ data: Data,
        @ViewBuilder content: @escaping (Data.Index, Data.Element) -> Content
    ) {
        self.data = data
        self.content = content
    }
}
