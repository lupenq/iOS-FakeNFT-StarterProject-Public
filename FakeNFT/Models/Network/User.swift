import Foundation

struct User: Decodable {
    let id: String
    let name: String
    let website: URL?
}
