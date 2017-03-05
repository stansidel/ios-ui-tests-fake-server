//
//  MyAppUITests.swift
//  MyAppUITests
//
//  Created by Stanislav Sidelnikov on 3/5/17.
//  Copyright © 2017 Stanislav Sidelnikov. All rights reserved.
//

import XCTest
import Swifter

class MyAppUITests: ServerUITestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
    
    func test200() {
        let endpoint = "company/blog/introducing-yandex-s-machine-intelligence-and-research-division"
        try! setup(server: defaultFakeServer, toRespondAt: [endpoint], withContentsOf: "TestResponse.html")
        try! launch(app: app, withServer: defaultFakeServer)
        
        app.buttons["Ask Server"].tap()
        let predicate = NSPredicate(format: "value CONTAINS[cd] %@", "AFH87-675AB")
        expectation(for: predicate, evaluatedWith: app.textViews["ServerResponse"], handler: nil)
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func test500() {
        let endpoint = "company/blog/*"
        defaultFakeServer[endpoint] = { _ -> HttpResponse in .internalServerError }
        try! launch(app: app, withServer: defaultFakeServer)
        
        app.buttons["Ask Server"].tap()
        let predicate = NSPredicate(format: "value CONTAINS[cd] %@", "code 500")
        expectation(for: predicate, evaluatedWith: app.textViews["ServerResponse"], handler: nil)
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
}
