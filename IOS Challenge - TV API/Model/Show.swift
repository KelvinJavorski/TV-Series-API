import Foundation

// MARK: - ShowClass
struct Show: Codable {
    let id: Int
    let url: String
    let name: String
    let image: Image?
    let genres: [String]
    let runtime, avarageRuntime: Int?
    let schedule: Schedule
    let summary: String
    let _embedded: Embedded?
}

struct Image: Codable {
    let medium, original: String
}

struct Schedule: Codable {
    let time: String
    let days: [String]
}

struct Embedded: Codable {
    let episodes: [Episode]?
}

struct Episode: Codable {
    let id: Int
    let url: String
    let name: String
    let season: Int
    let number: Int
    let image: Image?
    let summary: String?
}
