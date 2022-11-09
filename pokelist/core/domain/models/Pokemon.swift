//
//  Pokemon.swift
//  pokelist
//
//  Created by Rony on 08/11/22.
//

import Foundation

struct Pokemon: Decodable {
    let name: String
    let url: String
}

struct PokemonPage: Decodable {
    let count: Int
    let previous: String?
    let next: String?
    let results: [Pokemon]
}

struct PokemonDetails: Decodable {
    let id: Int
    let name: String
    let imageUrl: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        
        let sprites = try values.nestedContainer(keyedBy: SpritesKeys.self, forKey: .sprites)
        let otherSprites = try sprites.nestedContainer(keyedBy: OtherSpritesKeys.self, forKey: .other)
        let homeOtherSprites = try otherSprites.nestedContainer(keyedBy: HomeOtherSpritesKeys.self, forKey: .home)
        imageUrl = try homeOtherSprites.decode(String.self, forKey: .frontDefault)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case sprites
    }
    
    enum SpritesKeys: String, CodingKey {
        case other
    }
    
    enum OtherSpritesKeys: String, CodingKey {
        case home
    }
    
    enum HomeOtherSpritesKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
