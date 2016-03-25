//
//  LocalizedServerBuilder.swift
//  StaticWebsiteGenerator
//
//  Created by Denis Chaschin on 19.03.16.
//  Copyright © 2016 diniska. All rights reserved.
//

import Foundation

extension SimpleServerBuilder {
    public typealias LocalizedResponseGenerator = (Localization) -> String

    public func byAppendingRequest(request: LocalizedRequest, withResponse response: LocalizedResponseGenerator) -> SimpleServerBuilder {
        let wrapper = createResponse(request, response:  response)
        return byAppendingRequest(request, withResponse: wrapper)
    }

    public mutating func appendRequest(request: LocalizedRequest, withResponse response: LocalizedResponseGenerator) {
        let wrapper = createResponse(request, response:  response)
        appendRequest(request, withResponse: wrapper)
    }

    mutating func appendRequests<Sequence: SequenceType where Sequence.Generator.Element == LocalizedRequest>(requests: Sequence, withResponse response: LocalizedResponseGenerator) {
        requests.map { (request) -> (Request, Response) in
            let wrapper = createResponse(request, response:  response)
            return (request, wrapper)
        }.forEach {
            appendRequest($0.0, withResponse: $0.1)
        }
    }

    public func byAppendingRequests<Sequence: SequenceType where Sequence.Generator.Element == LocalizedRequest>(requests: Sequence, withResponse response: LocalizedResponseGenerator) -> SimpleServerBuilder {
        var res = self
        res.appendRequests(requests, withResponse: response)
        return res
    }

}

private func createResponse(request: LocalizedRequest, response: SimpleServerBuilder.LocalizedResponseGenerator) -> Response {
    return GeneratedStringResponse { response(request.localization) }
}