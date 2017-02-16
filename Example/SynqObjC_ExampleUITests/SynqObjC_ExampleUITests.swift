//
//  SynqObjC_ExampleUITests.swift
//  SynqObjC_ExampleUITests
//
//  Created by Kjartan Vestvik on 15.02.2017.
//  Copyright © 2017 kjartanvest. All rights reserved.
//

import XCTest

class SynqObjC_ExampleUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        
        // Check architecture to determine if running on simulator
        // If so, set env variable to stop camera from being started in SynqStreamer
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            var launchEnv = app.launchEnvironment
            launchEnv["UITesting"] = "YES"
            app.launchEnvironment = launchEnv
        #endif
        
        app.launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMainGuiAndPhotosPermission() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        addUIInterruptionMonitor(withDescription: "Photos Dialog") { (alert) -> Bool in
            alert.buttons["OK"].tap()
            return true
        }
        
        let app = XCUIApplication()
        app.tap() // need to interact with the app for the handler to fire
        
        // Check that the buttons exist
        XCTAssert(app.buttons["Upload"].exists)
        XCTAssert(app.buttons["Open StreamView"].exists)
    }
    
    func testStreamer() {
        
        let app = XCUIApplication()
        app.buttons["Open StreamView"].tap()
        
        #if (!arch(i386) && !arch(x86_64)) && os(iOS)
            addUIInterruptionMonitor(withDescription: "Camera Dialog") { (alert) -> Bool in
                alert.buttons["OK"].tap()
                return true
            }
            
            addUIInterruptionMonitor(withDescription: "Microphone Dialog") { (alert) -> Bool in
                alert.buttons["OK"].tap()
                return true
            }
            
            app.tap()
            
            XCTAssert(app.buttons["icSwitchCams"].exists)
            XCTAssert(app.buttons["icMicOff"].exists)
        #endif
        
        
        XCTAssert(app.buttons["icSettings"].exists)
        XCTAssert(app.buttons["icCloseWhite"].exists)
    }
    
}
