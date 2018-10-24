//
//  PeppermintUITests.swift
//  PeppermintUITests
//
//  Created by Luca Kaufmann on 06/05/2017.
//  Copyright © 2017 Luca Kaufmann. All rights reserved.
//

import XCTest

class PeppermintUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        
        let app = XCUIApplication()
        let button = app.scrollViews.otherElements.tables.buttons["Logout"]
        
        if (button.exists){
            button.tap()
        }
        snapshot("Launch")
        
        let usernameTextField = app.textFields["Username"]
        usernameTextField.tap()
        usernameTextField.typeText("lucakaufmann92@gmail.com")
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("kaelthas")
        app.buttons["Login"].tap()
         let mealsScrollViewsQuery = XCUIApplication().scrollViews.containing(.staticText, identifier:"Meals")
        mealsScrollViewsQuery.children(matching: .other).element(boundBy: 1).tap()
        snapshot("GroceryList")
        
//        let label = app.scrollViews.otherElements.tables.staticTexts["pizza"]
//        let object = app.staticTexts
//        let exists = NSPredicate(format: "exists == 1")
//        
//        expectation(for: exists, evaluatedWith: label, handler: nil)
//        waitForExpectations(timeout: 5, handler: nil)
        mealsScrollViewsQuery.children(matching: .other).element(boundBy: 0).tap()
        snapshot("MealsList")
        app.scrollViews.otherElements.tables.staticTexts["pizza"].tap()
        snapshot("MealDetail")
        app.buttons["Cancel"].tap()
        
        
       
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
