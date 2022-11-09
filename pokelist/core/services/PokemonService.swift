//
//  PokemonService.swift
//  pokelist
//
//  Created by Rony on 08/11/22.
//

import Foundation

class PokemonService: PokemonUseCases {
    var adapter: PokemonAdapter
    
    required init(adapter: PokemonAdapter) {
        self.adapter = adapter
    }
    
    func fetch(page: Int = 0) async throws -> PokemonPage {
        return try await self.adapter.fetch(page: page)
    }
    
    func findByName(_ name: String) async throws -> PokemonDetails {
        return try await self.adapter.findByName(name)
    }
}
