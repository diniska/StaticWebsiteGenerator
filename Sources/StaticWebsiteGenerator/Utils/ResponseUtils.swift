//
//  ResponseUtils.swift
//  StaticWebsiteGenerator
//
//  Created by Denis Chaschin on 17.03.16.
//  Copyright © 2016 diniska. All rights reserved.
//

import Foundation
import PathKit

class ResponseUtils {
    static func saveData(_ data: String, encoding: String.Encoding = String.Encoding.utf8, toFile file: Path) throws {
        debugPrint("creating path to file \(file)")
        try createDirectoriesToFile(file)
        debugPrint("writing file to path \(file)")
        try file.write(data, encoding: encoding)
    }
    
    static func saveData(_ data: Data, toFile file: Path) throws {
        try createDirectoriesToFile(file)
        try file.write(data)
    }

    static func copyFile(_ path: Path, toFile filePath: Path) throws {
        try createDirectoriesToFile(filePath)
        if filePath.exists {
            try filePath.delete()
        }
        try path.copy(filePath)
    }

    static func copyDirectory(_ path: Path, toDirectory pathToDirectory: Path) throws {
        try path.children().forEach { (children) in
            let newPath = pathToDirectory + children.lastComponent
            try copyAllFromPath(children, toPath: newPath)

        }
    }

    static func copyAllFromPath(_ src: Path, toPath dst: Path) throws {
        if src.isDirectory {
            try copyDirectory(src, toDirectory: dst)
        } else {
            try copyFile(src, toFile: dst)
        }
    }
}

private func createDirectoriesToFile(_ file: Path) throws {
    try file.parent().mkpath()
}
