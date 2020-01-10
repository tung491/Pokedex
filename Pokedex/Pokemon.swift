import Foundation

struct PokemonListResults: Codable {
    let results: [PokemonListResult]
}

struct PokemonListResult: Codable {
    let name: String
    let url: String
}

struct PokemonResult: Codable {
    let id: Int
    let name: String
    let types: [PokemonTypeEntry]
    let sprites: PokemonSprites
    let species: Species
}

struct Species: Codable {
    let url: String
}

struct PokemonTypeEntry: Codable {
    let slot: Int
    let type: PokemonType
}

struct PokemonType: Codable {
    let name: String
}

struct PokemonSprites: Codable {
    let front_default: String
}

struct PokemonSpecies: Codable {
    let flavor_text_entries: [PokemonFlavor]
}

struct PokemonFlavor: Codable {
    let language: Language
    let flavor_text: String
}

struct Language: Codable {
    let name: String
}
