//
//  Publisher.swift
//  SwiftPokedex
//
//  Created by Viktor Gidlöf on 2021-05-04.
//

import Combine

extension Publisher {
    func sink(to result: @escaping (Result<Output, Failure>) -> Void) -> AnyCancellable {
        sink { completion in
            switch completion {
            case let .failure(error): result(.failure(error))
            case .finished: break
            }
        } receiveValue: { value in
            result(.success(value))
        }
    }
}
