//
//  PokemonUseCases.swift
//  pokelist
//
//  Created by Rony on 08/11/22.
//

import Foundation

protocol PokemonUseCases {
    var adapter: PokemonAdapter {get}
    
    init (adapter: PokemonAdapter)
    
    func fetch(page: Int) async throws -> PokemonPage
    func findByName(_ name: String) async throws -> PokemonDetails
}
