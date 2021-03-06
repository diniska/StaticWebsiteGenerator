//
//  LocalizedServerBuilder.swift
//  StaticWebsiteGenerator
//
//  Created by Denis Chaschin on 19.03.16.
//  Copyright © 2016 diniska. All rights reserved.
//

import Foundation

extension SimpleServerBuilder {
    public typealias LocalizedResponseGenerator = (Localization) throws -> String

    public func byAppendingRequest(_ request: LocalizedRequest, withResponse response: @escaping LocalizedResponseGenerator) -> SimpleServerBuilder {
        byAppendingRequest(request, withResponse: createResponse(request, response:  response))
    }

    public mutating func appendRequest(_ request: LocalizedRequest, withResponse response: @escaping LocalizedResponseGenerator) {
        appendRequest(request, withResponse: createResponse(request, response:  response))
    }

    mutating func appendRequests<Sequence: Swift.Sequence>(_ requests: Sequence, withResponse response: @escaping LocalizedResponseGenerator) where Sequence.Iterator.Element == LocalizedRequest {
        requests.map { (request) -> (LocalizedRequest, Response) in
            let wrapper = createResponse(request, response: response)
            return (request, wrapper)
        }.forEach {
            appendRequest($0.0, withResponse: $0.1)
        }
    }

    public func byAppendingRequests<Sequence: Swift.Sequence>(_ requests: Sequence, withResponse response: @escaping LocalizedResponseGenerator) -> SimpleServerBuilder where Sequence.Iterator.Element == LocalizedRequest {
        var res = self
        res.appendRequests(requests, withResponse: response)
        return res
    }

}

private func createResponse(_ request: LocalizedRequest, response: @escaping SimpleServerBuilder.LocalizedResponseGenerator) -> Response {
    return GeneratedStringResponse { try response(request.localization) }
}
