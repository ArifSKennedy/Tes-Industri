//
//  UIImage.swift
//  SwiftPokedex
//
//  Created by Viktor Gidlöf on 2021-05-04.
//

import UIKit
import Combine

extension UIImage {
    private static var cancellables = Set<AnyCancellable>()

    static let pokedex = UIImage(named: "pokedex-icon")
    static let items = UIImage(named: "items-icon")

    static func load(from urlString: String, _ completion: @escaping (UIImage?) -> Swift.Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let imageURL = URL(string: urlString) else { DispatchQueue.main.async { completion(nil) }; return }

            let cache = URLCache.shared
            let request = URLRequest(url: imageURL)

            if let image = cache.image(from: request) {
                DispatchQueue.main.async { completion(image) }
            } else {
                URLSession.shared.dataTaskPublisher(for: request)
                    .tryMap { output -> Data in
                        cache.cacheImage(from: output, for: request)
                        return output.data
                    }
                    .tryMap { UIImage(data: $0) }
                    .sink { result in
                        switch result {
                        case let .success(image): completion(image)
                        case .failure: completion(nil)
                        }
                }.store(in: &cancellables)
            }
        }
    }
}
