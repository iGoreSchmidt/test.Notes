//
//  Resolver.swift
//  test.Notes.App
//
//  Created by zentity on 05/02/2020.
//  Copyright © 2020 Ing. Igor Shmidt. All rights reserved.
//

import Foundation
import test_Notes_API

public class Resolver {
    public enum Error: Swift.Error {
        case notRegistered
    }
    static let shared: Resolver = {
        let resolver = Resolver()
        resolver.register(RequestManager.self) { RequestManagerImpl(URL(string: "https://private-9aad-note10.apiary-mock.com/")!) }
        return resolver
    }()

    var storage = [String: Any]()
    var factory = [String: () -> Any]()

    public func resolve<T>() throws -> T {
        let typeName = String(describing: T.self)
        if let object = storage[typeName] as? T {
            return object
        }
        guard let object = factory[typeName]?() as? T else { throw Error.notRegistered }
        storage[typeName] = object
        return object
    }

    public func register(_ type: Any.Type, builder: @escaping () -> Any) {
        factory[String(describing: type)] = builder
    }
}
