//
//  Error.swift
//  StaticWebsiteGenerator
//
//  Created by Denis Chaschin on 13.03.16.
//  Copyright © 2016 diniska. All rights reserved.
//

import Foundation

public struct GeneratorError: Error {
    public var description: String
    init (_ description: String) {
        self.description = description
    }
}
