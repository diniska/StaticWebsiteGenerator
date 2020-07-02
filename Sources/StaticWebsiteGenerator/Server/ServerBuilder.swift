//
//  ServerBuilder.swift
//  
//
//  Created by Denis Chaschin on 22.04.2020.
//

import Foundation

@_functionBuilder
public struct ServerBuilder {
    public static func buildBlock(_ servers: Server...) -> [Server] {
        servers
    }
    
    public static func buildBlock(_ servers: Server...) -> ServerCluster {
        ServerCluster({ servers })
    }

    public static func buildBlock(_ tasks: ServerTask...) -> Server {
        var builder = SimpleServerBuilder()
        tasks.forEach {
            builder.appendRequest($0.request, withResponse: $0.response)
        }
        return builder.build()
    }
    
    public static func buildExpression(_ task: ServerTask) -> Server {
        SimpleServerBuilder()
            .byAppendingRequest(task.request, withResponse: task.response)
            .build()
    }

    public static func buildExpression(_ server: Server) -> Server {
        server
    }
    
}

public struct ServerTask {
    
    var request: Request
    var response: Response
    
    public init(request: Request, response: Response) {
        self.request = request
        self.response = response
    }
    
}
