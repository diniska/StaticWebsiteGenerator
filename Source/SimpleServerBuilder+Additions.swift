//
//  SimpleServerBuilder+Additions.swift
//  StaticWebsiteGenerator
//
//  Created by Denis Chaschin on 18.03.16.
//  Copyright © 2016 diniska. All rights reserved.
//

import Foundation

extension SimpleServerBuilder {
    mutating func appendRequests<Sequence: SequenceType, Element: Request where Sequence.Generator.Element == Element>(requests: Sequence, withResponse response: Response) {
        requests.forEach { appendRequest($0, withResponse: response) }
    }

    public func byAppendingRequests<Sequence: SequenceType, Element: Request where Sequence.Generator.Element == Element>(requests: Sequence, withResponse response: Response) -> SimpleServerBuilder {
        var res = self
        res.appendRequests(requests, withResponse: response)
        return res
    }
}