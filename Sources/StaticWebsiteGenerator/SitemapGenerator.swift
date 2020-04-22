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

    func createContext() -> [String: Any] {
        let requests = server.requestsPaths().sorted()
        let date = dateFormatter.string(from: Date())
        let result: [String: Any] = [
            "requests": requests,
            "date" : date,
            "baseUrl" : "\(scheme)://\(baseUrl)"
        ]
        return result
    }


    return GeneratedStringResponse {
        guard let resourcesPath = Bundle.currentBundle().resourcePath
            else { return emptyFileResponse }
        
        let environment = Environment(
            loader: FileSystemLoader(paths: [Path(resourcesPath)])
        )
        
        guard let result = try? environment.renderTemplate(name: "sitemap.xml", context: createContext())
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
        let environment = Environment(loader: FileSystemLoader(bundle: [Bundle.currentBundle()]))
        guard let template = try? environment.loadTemplate(name: "robots.txt")
            else { return emptyFileResponse }

        let context: [String: Any]
        if let parameters = parameters {
            let sitemaps = parameters.sitemapServer.requestsPaths().map {
                "\(parameters.scheme)://\(parameters.baseUrl)/\($0)"
            }
            context = [
                "sitemaps" : sitemaps
            ]
        } else {
            context = [:]
        }

        guard let result = try? template.render(context)
            else { return emptyFileResponse }

        return result
    }
}

private extension Server {
    func requestsPaths() -> [Path] {
        return supportedRequests
            .map { $0.url }
            .sorted { lhs, rhs in
                var lhsDirectories = lhs.lowercased().components(separatedBy: "/")
                if lhsDirectories.last == "" {
                    lhsDirectories = Array(lhsDirectories.dropLast())
                }
                var rhsDirectories = rhs.lowercased().components(separatedBy: "/")
                if rhsDirectories.last == "" {
                    rhsDirectories = Array(rhsDirectories.dropLast())
                }
                
                guard lhsDirectories.count == rhsDirectories.count
                    else {
                        return lhsDirectories.count < rhsDirectories.count
                    }
                
                for i in 0 ..< lhsDirectories.count {
                    guard lhsDirectories[i] == rhsDirectories[i]
                        else {
                            return lhsDirectories[i] < rhsDirectories[i]
                        }
                }
                return false // they are equal
            }
            .map { Path($0) }
    }
}
