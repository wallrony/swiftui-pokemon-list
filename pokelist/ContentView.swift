//
//  ContentView.swift
//  pokelist
//
//  Created by Rony on 08/11/22.
//

import SwiftUI

struct ContentView: View {
    @ViewBuilder
    var body: some View {
        NavigationView {
            PokemonListPage()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
