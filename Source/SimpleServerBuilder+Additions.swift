//
//  SimpleServerBuilder+Additions.swift
//  StaticWebsiteGenerator
//
//  Created by Denis Chaschin on 18.03.16.
//  Copyright © 2016 diniska. All rights reserved.
//

import Foundation

extension SimpleServerBuilder {
    mutating func appendRequests<Sequence: Swift.Sequence, Element: Request>(_ requests: Sequence, withResponse response: Response) where Sequence.Iterator.Element == Element {
        requests.forEach { appendRequest($0, withResponse: response) }
    }

    public func byAppendingRequests<Sequence: Swift.Sequence, Element: Request>(_ requests: Sequence, withResponse response: Response) -> SimpleServerBuilder where Sequence.Iterator.Element == Element {
        var res = self
        res.appendRequests(requests, withResponse: response)
        return res
    }
}
