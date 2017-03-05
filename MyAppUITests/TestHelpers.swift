//
//  TestHelpers.swift
//  MyApp
//
//  Created by Stanislav Sidelnikov on 3/5/17.
//  Copyright © 2017 Stanislav Sidelnikov. All rights reserved.
//

import XCTest
import Swifter

enum ServerUITestCaseError: Error {
    case fileNotFound(String)
    case failedToReadFile(String)
}

class ServerUITestCase: XCTestCase {
    var app: XCUIApplication!
    var defaultFakeServer: HttpServer!
    
    override func setUp() {
        super.setUp()
        setupDefaultFakeServer()
        app = XCUIApplication()
    }
    
    override func tearDown() {
        super.tearDown()
        defaultFakeServer.stop()
    }
    
    private func setupDefaultFakeServer() {
        defaultFakeServer?.stop()
        defaultFakeServer = HttpServer()
        defaultFakeServer.listenAddressIPv6 = "0:0:0:0:0:0:0:1"
        defaultFakeServer.listenAddressIPv4 = "127.0.0.1"
    }
    
    /// Passes the test server base address to the app via UI_TESTS_SERVER_BASE_URL environment,
    /// starts the server and launches the app. If the server is not specified, just launches the app.
    ///
    /// - Parameters:
    ///   - app: The application to launch.
    ///   - server: If specified, it's started and the address is passed the app prior to its launch.
    ///   - port: A port the server should listen to.
    /// - Throws: SocketError from the `server.start(port)` command.
    func launch(app: XCUIApplication, withServer server: HttpServer? = nil, port: in_port_t = 8080) throws {
        if let server = server {
            app.launchEnvironment["UI_TESTS_SERVER_BASE_URL"] = "http://localhost:\(port)"
            try server.start(port)
        }
        app.launch()
    }
    
    /// Setups the server to respond with the string from the file as the response body at the
    /// endpoints specified.
    ///
    /// - Parameters:
    ///   - server: The server to setup.
    ///   - paths: The endpoints the server should respond at with the string. On collision, the method overwrites
    ///            paths defined before.
    ///   - filename: The filename to read response string from. Should be like "SomeFile.xml".
    ///               It's read from the current bundle using the `contentOf(file)` method.
    /// - Throws: ServerUITestCaseError on failed file read.
    func setup(server: HttpServer, toRespondAt paths: [String], withContentsOf filename: String) throws {
        let contentString = try contentOf(file: filename)
        for path in paths {
            server[path] = { _ -> HttpResponse in .ok(.text(contentString)) }
        }
    }
    
    /// Reads contents of the file specified and returns it as a string. The file is looked at in
    /// the current bundle.
    ///
    /// - Parameter filename: The name of the file to read. Should be like "SomeFile.xml"
    /// - Returns: The string representation of the file's contents.
    /// - Throws: ServerUITestCaseError if the file is missing from the bundle. Make sure that the file
    ///           you're trying to read is included in the **test** target, not the app's one.
    func contentOf(file filename: String) throws -> String {
        let fileExt = filename.split(".").last ?? ""
        let baseName = filename.substring(to: filename.index(filename.endIndex,
                                                             offsetBy: -fileExt.characters.count - 1))
        guard let pathString = Bundle(for: type(of: self)).path(forResource: baseName, ofType: fileExt) else {
            throw ServerUITestCaseError.fileNotFound(filename)
        }
        
        guard let contentString = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            throw ServerUITestCaseError.failedToReadFile(filename)
        }
        
        return contentString
    }
}
