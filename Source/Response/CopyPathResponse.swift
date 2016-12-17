//
//  CopyPathResponse.swift
//  StaticWebsiteGenerator
//
//  Created by Denis Chaschin on 17.03.16.
//  Copyright © 2016 diniska. All rights reserved.
//

import Foundation
import PathKit

public protocol CopyPathResponse: Response {
    var path: Path { get }
}

public extension CopyPathResponse {
    func saveDataToPath(_ path: Path) throws {
        try ResponseUtils.copyAllFromPath(self.path, toPath: path)
    }
}

public struct StaticCopyPathResponse: CopyPathResponse {
    public let path: Path
    public init(path: Path) {
        self.path = path
    }
    public init(path: String) {
        self.path = Path(path)
    }
}
