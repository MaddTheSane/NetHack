//
//  AppDelegate.swift
//  SwiftHack
//
//  Created by C.W. Betts on 2/18/16.
//  Copyright © 2016 C.W. Betts. All rights reserved.
//

import Cocoa

func swift_init_nhwindows(argc: UnsafeMutablePointer<Int32>, argv: UnsafeMutablePointer<UnsafeMutablePointer<Int8>>) {
	iflags.window_inited = true;
}

func swift_win_putstr(winID: winid, flags: Int32, str: UnsafePointer<Int8>) {
	
}

class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!


	func applicationDidFinishLaunching(aNotification: NSNotification) {
		// Insert code here to initialize your application
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}


}

