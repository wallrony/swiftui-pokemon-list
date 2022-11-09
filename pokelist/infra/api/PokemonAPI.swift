//
//  PokemonAPI.swift
//  pokelist
//
//  Created by Rony on 08/11/22.
//

import Foundation

class PokemonAPI: PokemonAdapter {
    func fetch(page: Int = 0) async throws -> PokemonPage {
        let limit = 20
        var url = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
        url.append(queryItems: [URLQueryItem(name: "offset", value: String(page * limit))])
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw InfraErrors.UnexpectedError(message: "An unexpected error occurred. Please contact the support.")
        }
        if let page = try? JSONDecoder().decode(PokemonPage.self, from: data) {
            return page
        }
        throw InfraErrors.UnexpectedError(message: "An unexpected error occurred. Please contact the support.")
    }
    
    func findByName(_ name: String) async throws -> PokemonDetails {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(name)")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw InfraErrors.UnexpectedError(message: "An unexpected error occurred. Please contact the support.")
        }
        if let pokemonDetails = try? JSONDecoder().decode(PokemonDetails.self, from: data) {
            return pokemonDetails
        }
        throw InfraErrors.UnexpectedError(message: "An unexpected error occurred. Please contact the support.")
    }
}
