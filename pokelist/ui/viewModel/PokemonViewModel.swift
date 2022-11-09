//
//  PokemonController.swift
//  pokelist
//
//  Created by Rony on 08/11/22.
//

import SwiftUI

@MainActor
class PokemonViewModel: ObservableObject {
    private let service: PokemonUseCases = PokemonService(adapter: PokemonAPI())
    
    init() {
        Task { await self.fetch() }
    }
    
    @Published var data: PokemonPage = PokemonPage(count: 0, previous: nil, next: nil, results: [Pokemon]())
    @Published var isLoading: Bool = false
    @Published var hasNextPage: Bool = false
    @Published var hasPreviousPage: Bool = false
    var pageNumber: Int = 0
    
    @MainActor
    func fetch(page: Int? = nil) async {
        self.isLoading = true
        do {
            let data = try await self.service.fetch(page: page ?? pageNumber)
            self.data = data
            hasNextPage = data.next != nil
            hasPreviousPage = data.previous != nil
            pageNumber = page ?? pageNumber
        } catch let error as InfraErrors {
            switch(error) {
            case InfraErrors.UnexpectedError:
                print(error.localizedDescription)
                break
            }
        } catch let error {
            print(error.localizedDescription)
        }
        self.isLoading = false
    }
    
    func fetchNextPage() async {
        guard self.data.next != nil else {
            return
        }
        await self.fetch(page: self.pageNumber + 1)
    }
    
    func fetchPreviousPage() async {
        guard self.data.previous != nil else {
            return
        }
        await self.fetch(page: self.pageNumber - 1)
    }

    func findByName(_ name: String) async -> PokemonDetails? {
        do {
            return try await self.service.findByName(name)
        } catch let error as InfraErrors {
            switch(error) {
            case InfraErrors.UnexpectedError:
                print(error.localizedDescription)
                break
            }
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }

    @ViewBuilder
    var list: some View {
        if self.isLoading {
            ProgressView().progressViewStyle(CircularProgressViewStyle())
        } else {
            List(self.isLoading ? [Pokemon]() : self.data.results, id: \.name) { pokemon in
                self.pokemonRow(pokemon)
            }
        }
    }
    
    @ViewBuilder
    func pokemonRow(_ pokemon: Pokemon) -> some View {
        NavigationLink(destination: PokemonDetailsPage(modelView: self, pokemonName: pokemon.name)) {
            HStack {
                Text(pokemon.name.capitalized)
            }
        }
    }
    
    @ViewBuilder
    func pokemonDetailsCard(pokemonDetails: PokemonDetails) -> some View {
        HStack {
            Image.fromURL(url: pokemonDetails.imageUrl)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .navigationTitle(pokemonDetails.name.capitalized)
        }.frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
        ).padding()
    }
}
