//
//  ImageExtension.swift
//  pokelist
//
//  Created by Rony on 09/11/22.
//

import SwiftUI

extension Image {
    static func fromURL(url: String) -> Self {
        let urlObj = URL(string: url)!
        if let data = try? Data(contentsOf: urlObj) {
            return Image(uiImage: UIImage(data: data)!)
                .resizable()
        }
        return Image(systemName: "square.and.arrow.down").resizable()
    }
}
