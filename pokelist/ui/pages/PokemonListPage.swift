//
//  PokemonListPage.swift
//  pokelist
//
//  Created by Rony on 09/11/22.
//

import SwiftUI

struct PokemonListPage: View {
    @ObservedObject var viewModel: PokemonViewModel
    init() {
        self.viewModel = PokemonViewModel()
    }
    
    var body: some View {
        viewModel.list
        .navigationTitle(Text("Pokemons"))
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    Task {
                        await viewModel.fetchPreviousPage()
                    }
                }) {
                    Image(systemName: "chevron.left")
                    Text("Previous")
                }.disabled(!viewModel.hasPreviousPage)

                Button(action: {
                    Task {
                        await viewModel.fetchNextPage()
                    }
                }) {
                    Text("Next")
                    Image(systemName: "chevron.right")
                }.disabled(!viewModel.hasNextPage)
            }
        }.refreshable {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                Task {
                    await viewModel.fetch()
                }
            }
        }
    }
}

struct PokemonListPage_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListPage()
    }
}
