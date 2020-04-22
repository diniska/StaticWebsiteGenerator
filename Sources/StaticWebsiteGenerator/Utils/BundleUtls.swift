//
//  BundleUtls.swift
//  StaticWebsiteGenerator
//
//  Created by Denis Chaschin on 14.03.16.
//  Copyright © 2016 diniska. All rights reserved.
//

import Foundation

private class Bundle {}

extension Foundation.Bundle {
    static func currentBundle() -> Foundation.Bundle {
        return self.init(for: Bundle.self)
    }
}
