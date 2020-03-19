//
//  Sharing_Images_DemoUITests.swift
//  Sharing_Images_DemoUITests
//
//  Created by it thinkers on 2/26/20.
//  Copyright © 2020 ibrahim-attalla. All rights reserved.
//

import XCTest

class Sharing_Images_DemoUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func testExample() {
//        // UI tests must launch the application that they test.
//        let app = XCUIApplication()
//        app.launch()
//
//        // Use recording to get started writing UI tests.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
    
    func testFullCycleFromLoginToLgout(){
        
        

        let validEmail = "hima@yahoo.com"
        let validPassword = "123456"

        let app = XCUIApplication()
        let elementsQuery = app.scrollViews.otherElements
        
        // userNameTF
        let userNameTF = elementsQuery.textFields["E_mail"]
        XCTAssertTrue(userNameTF.exists)
        userNameTF.tap()
        userNameTF.typeText(validEmail)

        //  passwordTF
        let passwordTF = elementsQuery.secureTextFields["Password"]
        XCTAssertTrue(passwordTF.exists)
        passwordTF.tap()
        passwordTF.typeText(validPassword)
        
        // MARK:- to login screen
         // elementsQuery.buttons["Login"].tap()
        let loginBtnPressed = elementsQuery.buttons["Login"]
        loginBtnPressed.tap()
        
        
        // MARK:- test if the next screen is Home one
        let homeBoardView = app.otherElements["view_Homeboard"]
        let homeBoardShown = homeBoardView.waitForExistence(timeout: 5)
        XCTAssert(homeBoardShown)

        // test swipe
        app.swipeUp()
        app.swipeUp()
        app.swipeDown()
        
        // TODO:- test selection of some cells
        
        
        
        // MARK:- test navigate to profile screen by tabBar
        let profielTab = app.tabBars.buttons["Profile"]
        let homeTap = app.tabBars.buttons["Home"]
        profielTab.tap()
        
        // MARK:- test if the next screen is Profile one
        let ProfileBoardView = app.otherElements["view_Profileboard"]
        let ProfileBoardShown = ProfileBoardView.waitForExistence(timeout: 1)
        XCTAssert(ProfileBoardShown)

        // MARK:- test scrolling of images collection  at profile view
        let imagesCollection = app.collectionViews
        let scrolling = imagesCollection.containing(.other, identifier: "Vertical scroll bar, 12 pages").element
        scrolling.swipeUp()
        scrolling.swipeDown()
        scrolling.swipeUp()

        
        // MARK:- access Camera
        
        
        /*  VV IMP if you get any view from snapshot with incorrect name the next error helper will help you 😉😉
         Failed to get matching snapshot: No matches found for Elements matching predicate '"camera" IN identifiers' from input {(
             Button, label: 'Home',
             Button, label: 'Profile', Selected,
             Button, label: 'edit',
             Button, label: 'cameraIcone',
             Button, label: 'logout'
         )}
         */
        
//        app.buttons["cameraIcone"].tap()
//        app.buttons["CANCEL"].tap()
//        app/*@START_MENU_TOKEN@*/.buttons["cameraIcone"]/*[[".otherElements[\"view_Profileboard\"].buttons[\"cameraIcone\"]",".buttons[\"cameraIcone\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        app.sheets.scrollViews.otherElements.buttons["CAMERA"].tap()
//        app/*@START_MENU_TOKEN@*/.buttons["PhotoCapture"]/*[[".buttons[\"Take Picture\"]",".buttons[\"PhotoCapture\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        app.buttons["Use Photo"].tap()

        
        // MARK:- test logout Btn
        let logoutBtn  = app.buttons["logout"]
        logoutBtn.tap()
        
        
        
            }
    

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
