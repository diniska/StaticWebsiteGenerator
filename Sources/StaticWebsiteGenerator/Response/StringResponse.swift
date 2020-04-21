//
//  StringResponse.swift
//  StaticWebsiteGenerator
//
//  Created by Denis Chaschin on 17.03.16.
//  Copyright © 2016 diniska. All rights reserved.
//

import Foundation
import PathKit

public protocol StringResponse: Response {
    func response() throws -> String
}

public extension StringResponse {
    func saveDataToPath(_ path: Path) throws {
        try ResponseUtils.saveData(try response(), toFile: path)
    }
}

public struct StaticStringResponse: StringResponse {
    private let _response: String
    public func response() throws -> String { _response }
    public init(response: String) {
        _response = response
    }
}

public struct GeneratedStringResponse: StringResponse {
    public typealias Generator = () throws -> String
    public init(generator: @escaping Generator) {
        self.generator = generator
    }
    public var generator: Generator
    public func response() throws -> String { try generator() }
}
