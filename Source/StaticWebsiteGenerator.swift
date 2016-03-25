//
//  StaticWebsiteGenerator.swift
//  StaticWebsiteGenerator
//
//  Created by Denis Chaschin on 13.03.16.
//  Copyright © 2016 diniska. All rights reserved.
//

import Foundation
import PathKit


public struct StaticWebsiteGenerator {

    public init() {}

    private var outputPath: Path? = nil
    private var server: Server?

    public func withOutputPath(path: String) -> StaticWebsiteGenerator {
        var result = self
        result.outputPath = Path(path)
        return result
    }

    public func withServer(server: Server) -> StaticWebsiteGenerator {
        var result = self
        result.server = server
        return result
    }

    public func generate() throws {
        guard let server = server
            else { throw Error("There is no website producer") }
        guard let outputPath = outputPath
            else { throw Error("There is no output path") }

        try server.supportedRequests.forEach { (request) in
            debugPrint("performing request \(request.url)")

            try server.performRequest(request) { (response) in
                guard let response = response
                    else { debugPrint("There is no response for request \(request.url)"); return }

                let lastPathPart: String

                if request.url.isEmpty || request.url.characters.last == "/" {
                    lastPathPart = request.url + "index.html"
                } else {
                    lastPathPart = request.url
                }

                try response.saveDataToPath(outputPath + lastPathPart)
            }
        }
    }
}
