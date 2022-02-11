//
//  Ness_Botanic_Garden_VisitorUITestsLaunchTests.swift
//  Ness Botanic Garden VisitorUITests
//
//  Created by Jake Darby on 11/02/2022.
//

import XCTest

class Ness_Botanic_Garden_VisitorUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
