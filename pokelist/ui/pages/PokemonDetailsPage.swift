//
//  PokemonDetailsPage.swift
//  pokelist
//
//  Created by Rony on 09/11/22.
//

import SwiftUI

struct PokemonDetailsPage: View {
    var viewModel: PokemonViewModel
    let pokemonName: String
    @State var pokemonDetails: PokemonDetails?
    @Environment(\.presentationMode) var presentationMode
    
    init(modelView pokemonModelView: PokemonViewModel, pokemonName: String) {
        self.viewModel = pokemonModelView
        self.pokemonName = pokemonName
    }
    
    func loadPokemonDetails() {
        Task {
            let data = await viewModel.findByName(pokemonName)
            if data == nil {
                self.presentationMode.wrappedValue.dismiss()
            } else {
                self.pokemonDetails = data
            }
        }
    }
    
    var body: some View {
        if self.pokemonDetails == nil {
            ProgressView().progressViewStyle(CircularProgressViewStyle())
                .navigationTitle(pokemonName.capitalized)
            let _ = loadPokemonDetails()
        } else {
            self.viewModel.pokemonDetailsCard(pokemonDetails: self.pokemonDetails!)
        }
    }
}

struct PokemonDetailsPage_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailsPage(modelView: PokemonViewModel(), pokemonName: "charizard")
    }
}
