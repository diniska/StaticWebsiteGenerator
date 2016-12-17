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
    var response: String { get }
}

public extension StringResponse {
    func saveDataToPath(_ path: Path) throws {
        try ResponseUtils.saveData(response, toFile: path)
    }
}

public struct StaticStringResponse: StringResponse {
    public let response: String
    public init(response: String) {
        self.response = response
    }
}

public struct GeneratedStringResponse: StringResponse {
    public typealias Generator = () -> String
    public init(generator: @escaping Generator) {
        self.generator = generator
    }
    public var generator: Generator
    public var response: String {
        return generator()
    }
}
