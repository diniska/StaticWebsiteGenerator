//
//  ServerCluster.swift
//  StaticWebsiteGenerator
//
//  Created by Denis Chaschin on 18.03.16.
//  Copyright © 2016 diniska. All rights reserved.
//

import Foundation

public struct ServerCluster {
    fileprivate var servers: [Server] = []
    public init() {}

    fileprivate init(servers: [Server]) {
        self.servers = servers
    }

    public mutating func appendServer(_ server: Server) {
        servers.append(server)
    }
    public func withServer(_ server: Server) -> ServerCluster{
        var res = self
        res.appendServer(server)
        return res
    }
}

extension ServerCluster: Server {
    public func performRequest(_ request: Request, callback: (Response?) throws -> ()) throws {
        var responded = false
        for server in servers {
            if server.supportsRequest(request) {
                try server.performRequest(request, callback: callback)
                responded = true
                break
            }
        }
        if !responded {
            throw GeneratorError("There is no server in cluster that handle such request")
        }
    }

    public var supportedRequests: [Request] {
        return servers.map { $0.supportedRequests }.reduce([], +)
    }

    public func supportsRequest(_ request: Request) -> Bool {
        for server in servers {
            if server.supportsRequest(request) {
                return true
            }
        }
        return false
    }
}

func +(lhs: ServerCluster, rhs: ServerCluster) -> ServerCluster {
    return ServerCluster(servers: lhs.servers + rhs.servers)
}
