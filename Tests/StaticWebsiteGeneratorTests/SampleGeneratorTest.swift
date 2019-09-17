//
//  SampleGeneratorTest.swift
//  
//
//  Created by Denis Chaschin on 17.09.2019.
//

import Foundation
import XCTest
@testable import StaticWebsiteGenerator

//TODO: improve this to actually test something
@available(OSX 10.12, *)
final class SampleGeneratorTestTests: XCTestCase {
    private let baseUrl = "example.org"
    private var outputPath: String!
    
    override func setUp() {
        outputPath = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).path
        try! FileManager.default.createDirectory(atPath: outputPath, withIntermediateDirectories: true, attributes: nil)
    }
    
    override func tearDown() {
        try! FileManager.default.removeItem(atPath: outputPath)
    }
    
    func testSampleService() {
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
print(outputPath)
        XCTAssertNoThrow(try generator.generate())
    }

    static var allTests = [
        ("testExample", testSampleService),
    ]
}
