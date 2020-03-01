//
//  Sharing_Images_DemoTests.swift
//  Sharing_Images_DemoTests
//
//  Created by it thinkers on 2/26/20.
//  Copyright © 2020 ibrahim-attalla. All rights reserved.
//

import XCTest
@testable import Sharing_Images_Demo

class LoginTests: XCTestCase {
    
    var loginVM: LoginViewModel!
    var loginGatewayMoke: LoginGatwayMoke!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        loginGatewayMoke = LoginGatwayMoke()
        loginVM = LoginViewModel(authGateway: loginGatewayMoke)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLoginCalling(){
        loginVM.initLogin(email: "hima@yahoo.com", password: "xxx")
        XCTAssert(loginGatewayMoke.isLogin == true)
    }



}

class LoginGatwayMoke: APILoginServiceProtocol {
    var isLogin : Bool = false
    
    func login(email: String, password: String, complete: @escaping (Bool?, String?) -> ()) {
        isLogin = true
    }
    
    
}
