//
//  AutobotUITests.swift
//  AutobotUITests
//
//  Created by Agam Mahajan on 16/08/16.
//  Copyright © 2016 Agam Mahajan. All rights reserved.
//

import XCTest

class AutobotUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let app = XCUIApplication()
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["More"].tap()
        app.buttons["SignOut"].tap()
        
        let areYouSureSheet = app.sheets["Are you sure?"]
        app.buttons["Reports"].tap()
        XCUIDevice.sharedDevice().orientation = .Portrait
        XCUIDevice.sharedDevice().orientation = .Portrait
        XCUIDevice.sharedDevice().orientation = .Portrait
        XCUIDevice.sharedDevice().orientation = .Portrait
        app.navigationBars["Detail"].buttons["JOBS"].tap()
        let yesButton = areYouSureSheet.collectionViews.buttons["Yes"]
        yesButton.tap()
        yesButton.tap()
        yesButton.tap()
        areYouSureSheet.buttons["NO"].tap()
        app.otherElements.containingType(.Sheet, identifier:"Are you sure?").element.tap()
        tabBarsQuery.buttons["Most Recent"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.searchFields["Search a Project"].tap()
        app.searchFields["Search a Project"]
        app.buttons["Cancel"].tap()
        tablesQuery.staticTexts["Shriniketan"].tap()
        app.navigationBars["Detail"].buttons["JOBS"].tap()
        
        app.buttons["GIDSignInButton"].tap()
        app.tables.cells.containingType(.StaticText, identifier:"2216(Fabric)").staticTexts["Failed"].swipeUp()
        XCUIApplication().navigationBars["JOBS"].staticTexts["JOBS"].tap()
        
        tablesQuery.staticTexts["2200(Fabric)"].tap()
        tablesQuery.cells.containingType(.StaticText, identifier:"2203(Fabric)").childrenMatchingType(.StaticText).matchingIdentifier("Priyadharshini.m").elementBoundByIndex(0).tap()
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}


