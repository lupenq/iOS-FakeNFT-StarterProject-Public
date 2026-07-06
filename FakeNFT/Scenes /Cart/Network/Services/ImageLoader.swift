//
//  ImageLoader.swift
//  FakeNFT
//
//  Created by Artem Yaroshenko on 04.07.2026.
//

import UIKit

protocol ImageLoader {
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void)
}

final class DefaultImageLoader: ImageLoader {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString), !urlString.isEmpty else {
            completion(nil)
            return
        }

        session.dataTask(with: url) { data, _, _ in
            guard let data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }.resume()
    }
}
