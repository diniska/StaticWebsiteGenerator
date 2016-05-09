//
//  MyWebsiteGenerator.swift
//  StaticWebsiteGeneratorExample
//
//  Created by Denis Chaschin on 25.03.16.
//  Copyright © 2016 diniska. All rights reserved.
//

import Foundation
import StaticWebsiteGenerator

private let baseUrl = "example.org"

class MyWebsiteGenerator {
    let outputPath: String

    init (outputPath: String) {
        self.outputPath = outputPath
    }

    func generate() throws {

        let htmlServer = SimpleServerBuilder()
            .byAppendingRequest(SimpleRequest(url: ""), withResponse: StaticStringResponse(response: "Hello World!"))
            .build()

        let sitemapServer = SimpleServerBuilder()
            .byAppendingRequest(SimpleRequest(url: "sitemap.xml"), withResponse: createSitemapGenerator(htmlServer, baseUrl: baseUrl))
            .build()

        let robotsTXTParameters = RobotsTXTParameters(sitemapServer: sitemapServer, baseUrl: baseUrl)

        let robotsTXTServer = SimpleServerBuilder()
            .byAppendingRequest(SimpleRequest(url: "robots.txt"), withResponse: createRobotsTXTGenerator(robotsTXTParameters))
            .build()

        let allServers = ServerCluster()
            .withServer(htmlServer)
            .withServer(sitemapServer)
            .withServer(robotsTXTServer)

        let generator = Generator()
            .withOutputPath(outputPath)
            .withServer(allServers)

        try generator.generate()
    }
}