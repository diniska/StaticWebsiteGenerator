//
//  SimpleServerBuilder.swift
//  StaticWebsiteGenerator
//
//  Created by Denis Chaschin on 17.03.16.
//  Copyright © 2016 diniska. All rights reserved.
//

import Foundation

private typealias SimpleServerData = [HashableRequest : Response]

public struct SimpleServerBuilder {
    public init() {}

    private var data: SimpleServerData  = SimpleServerData()
    public func byAppendingRequest(request: Request, withResponse response: Response) -> SimpleServerBuilder {
        var res = self
        res.appendRequest(request, withResponse: response)
        return res
    }

    public mutating func appendRequest(request: Request, withResponse response: Response) {
        data[wrap(request)] = response
    }

    public func build() -> Server {
        return SimpleServer(data: data)
    }
}

private struct SimpleServer: Server {
    var data: SimpleServerData
    func performRequest(request: Request, callback: (Response?) throws -> ()) throws {
        let response = data[wrap(request)]
        try callback(response)
    }
    var supportedRequests: [Request] {
        return data.keys.map(unwrap)
    }
    private func supportsRequest(request: Request) -> Bool {
        return data.keys.contains(wrap(request))
    }
}
