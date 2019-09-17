//
//  SimpleRequest.swift
//  StaticWebsiteGenerator
//
//  Created by Denis Chaschin on 19.03.16.
//  Copyright © 2016 diniska. All rights reserved.
//

import Foundation

public struct SimpleRequest: Request {
    public var url: String
    
    public init(url: String) {
        self.url = url
    }
}