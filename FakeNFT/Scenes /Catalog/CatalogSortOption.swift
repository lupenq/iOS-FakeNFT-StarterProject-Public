import Foundation

enum CatalogSortOption: String {
    case name
    case nftCount

    static let `default`: CatalogSortOption = .nftCount
}

final class CatalogSortStore {

    private let defaults: UserDefaults
    private let key = "catalog.sortOption"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var option: CatalogSortOption {
        get {
            guard
                let raw = defaults.string(forKey: key),
                let option = CatalogSortOption(rawValue: raw)
            else {
                return .default
            }
            return option
        }
        set {
            defaults.set(newValue.rawValue, forKey: key)
        }
    }
}
