//
//  StaticWebsiteGenerator.swift
//  StaticWebsiteGenerator
//
//  Created by Denis Chaschin on 13.03.16.
//  Copyright © 2016 diniska. All rights reserved.
//

import Foundation
import PathKit


public struct Generator {

    public init() {}

    fileprivate var outputPath: Path? = nil
    fileprivate var server: Server?

    public func withOutputPath(_ path: String) -> Generator {
        var result = self
        result.outputPath = Path(path)
        return result
    }

    public func withServer(_ server: Server) -> Generator {
        var result = self
        result.server = server
        return result
    }

    public func generate() throws {
        guard let server = server
            else { throw GeneratorError("There is no website producer") }
        guard let outputPath = outputPath
            else { throw GeneratorError("There is no output path") }

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
