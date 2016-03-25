//
//  LocalizedRequest.swift
//  StaticWebsiteGenerator
//
//  Created by Denis Chaschin on 13.03.16.
//  Copyright © 2016 diniska. All rights reserved.
//

import Foundation

public typealias Localization = String

public struct LocalizedRequest: Request {

    public var path: String
    public var localization: Localization

    public var url: String  {
        return "\(localization)/\(path)"
    }
}

extension LocalizedRequest: Hashable {
    public var hashValue: Int {
       return url.hashValue
    }
}

public func ==(lhs: LocalizedRequest, rhs: LocalizedRequest) -> Bool {
    return lhs.path == rhs.path && lhs.localization == rhs.localization
}

extension LocalizedRequest {
    public static func withRequest<Sequence: SequenceType where Sequence.Generator.Element == String>(path: String, localizations: Sequence) -> [LocalizedRequest] {
        return localizations.map {
            LocalizedRequest(path: path, localization: $0)
        }
    }
}