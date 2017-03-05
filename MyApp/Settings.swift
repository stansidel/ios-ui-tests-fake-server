//
//  Settings.swift
//  MyApp
//
//  Created by Stanislav Sidelnikov on 3/5/17.
//  Copyright © 2017 Stanislav Sidelnikov. All rights reserved.
//

import Foundation

class Settings {
    var apiBaseUrl: String {
        if let uiTestsServerUrl = ProcessInfo.processInfo.environment["UI_TESTS_SERVER_BASE_URL"] {
            return uiTestsServerUrl
        } else {
            return "https://yandex.com"
        }
    }
}
