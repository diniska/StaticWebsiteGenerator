//
//  ServerCluster.swift
//  StaticWebsiteGenerator
//
//  Created by Denis Chaschin on 18.03.16.
//  Copyright © 2016 diniska. All rights reserved.
//

import Foundation

public struct ServerCluster {
    private var servers: [Server] = []
    public init() {}

    private init(servers: [Server]) {
        self.servers = servers
    }

    public mutating func appendServer(server: Server) {
        servers.append(server)
    }
    public func withServer(server: Server) -> ServerCluster{
        var res = self
        res.appendServer(server)
        return res
    }
}

extension ServerCluster: Server {
    public func performRequest(request: Request, callback: (Response?) throws -> ()) throws {
        var responded = false
        for server in servers {
            if server.supportsRequest(request) {
                try server.performRequest(request, callback: callback)
                responded = true
                break
            }
        }
        if !responded {
            throw Error("There is no server in cluster that handle such request")
        }
    }

    public var supportedRequests: [Request] {
        return servers.map { $0.supportedRequests }.reduce([], combine: +)
    }

    public func supportsRequest(request: Request) -> Bool {
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