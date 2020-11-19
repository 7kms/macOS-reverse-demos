//
//  AppDelegate.swift
//  crackme
//
//  Created by 公里柒 on 2020/11/16.
//  Copyright © 2020 km7. All rights reserved.
//

import Cocoa


//@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
//        NSWindowController(stro)
        let controller = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "first") as! NSWindowController
        
        (controller.window?.contentViewController as! ViewController).window = controller.window
        controller.showWindow(self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

}



