import Foundation

extension Array where Element == String {
    /// Разворачивает идентификаторы, которые мок-сервер может возвращать склеенными через запятую,
    /// в плоский список непустых id (например `["1,2", "3"]` -> `["1", "2", "3"]`).
    var normalizedIds: [String] {
        flatMap { $0.split(separator: ",") }
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }
}
