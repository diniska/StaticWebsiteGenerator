//
//  SitemapGenerator.swift
//  StaticWebsiteGenerator
//
//  Created by Denis Chaschin on 14.03.16.
//  Copyright © 2016 diniska. All rights reserved.
//

import Foundation
import Stencil
import PathKit

private let dateFormatter: DateFormatter = {
    let res = DateFormatter()
    res.dateFormat = "yyyy-MM-dd"
    return res
}()

private let emptyFileResponse = ""

public func createSitemapGenerator(_ server: Server, baseUrl: String, scheme: String = "http") -> Response {

    func createContextDictionary() -> [String: Any] {
        let requests = createRequestsPaths(server)
        let date = dateFormatter.string(from: Date())
        let result: [String: Any] = [
            "requests": requests,
            "date" : date,
            "baseUrl" : "\(scheme)://\(baseUrl)"
        ]
        return result
    }


    return GeneratedStringResponse {
        guard let template = try? Template(named: "sitemap.xml", inBundle: Bundle.currentBundle())
            else { return emptyFileResponse }

        let dictionary = createContextDictionary()
        let context = Context(dictionary: dictionary)

        guard let result = try? template.render(context)
            else { return emptyFileResponse }

        return result
    }
}

//http://www.sitemaps.org/protocol.html#informing
public struct RobotsTXTParameters {
    public var sitemapServer: Server
    public var baseUrl: String
    public var scheme: String

    public init(sitemapServer: Server, baseUrl: String, scheme: String = "http") {
        self.sitemapServer = sitemapServer
        self.baseUrl = baseUrl
        self.scheme = scheme
    }
}

public func createRobotsTXTGenerator(_ parameters: RobotsTXTParameters?) -> Response {
    return GeneratedStringResponse {
        guard let template = try? Template(named: "robots.txt", inBundle: Bundle.currentBundle())
            else { return emptyFileResponse }

        let dictionary: [String: Any]
        if let parameters = parameters {
            let sitemaps = createRequestsPaths(parameters.sitemapServer).map {
                "\(parameters.scheme)://\(parameters.baseUrl)/\($0)"
            }
            dictionary = [
                "sitemaps" : sitemaps
            ]
        } else {
            dictionary = [:]
        }
        let context = Context(dictionary: dictionary)

        guard let result = try? template.render(context)
            else { return emptyFileResponse }

        return result
    }
}

func createRequestsPaths(_ server: Server) -> [Path] {
    return server.supportedRequests.map { $0.url }.map { Path($0) }
}
