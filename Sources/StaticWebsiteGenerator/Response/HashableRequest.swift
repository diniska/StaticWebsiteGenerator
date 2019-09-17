//
//  HashableRequest.swift
//  StaticWebsiteGenerator
//
//  Created by Denis Chaschin on 19.03.16.
//  Copyright © 2016 diniska. All rights reserved.
//

import Foundation

struct HashableRequest {
    var request: Request
}

extension HashableRequest: Hashable {
    var hashValue: Int {
        return request.url.hashValue
    }
}

func ==(lhs: HashableRequest, rhs: HashableRequest) -> Bool {
    return lhs.request.url == rhs.request.url
}

func wrap(_ request: Request) -> HashableRequest {
    return HashableRequest(request: request)
}

func unwrap(_ hashableRequest: HashableRequest) -> Request {
    return hashableRequest.request
}
