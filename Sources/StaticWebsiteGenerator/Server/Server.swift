//
//  Server.swift
//  StaticWebsiteGenerator
//
//  Created by Denis Chaschin on 17.03.16.
//  Copyright © 2016 diniska. All rights reserved.
//

import Foundation
import PathKit

public protocol Request {
    var url: String { get }
}

public protocol Response {
    func saveDataToPath(_ path: Path) throws
}

public protocol Server {
    func performRequest(_ request: Request, callback: (Response?) throws -> ()) throws
    var supportedRequests: [Request] { get }
    func supportsRequest(_ request: Request) -> Bool
}
