//
//  AppDelegate.swift
//  StaticWebsiteGeneratorExample
//
//  Created by Denis Chaschin on 25.03.16.
//  Copyright © 2016 diniska. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let generator = MyWebsiteGenerator(outputPath: Bundle.main.bundlePath + "/Result")

        do {
            try generator.generate()
        } catch {
            debugPrint("unable to generate website")
        }

        NSWorkspace.shared().openFile(generator.outputPath)
    }

    func applicationWillTerminate(_ aNotification: Notification) {}

}

