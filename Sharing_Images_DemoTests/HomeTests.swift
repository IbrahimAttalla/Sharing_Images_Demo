//
//  HomeTests.swift
//  Sharing_Images_DemoTests
//
//  Created by it thinkers on 2/26/20.
//  Copyright © 2020 ibrahim-attalla. All rights reserved.
//

import XCTest
@testable import Sharing_Images_Demo

class HomeTests: XCTestCase {

    var homeVM: HomeViewModel!
    var homeGateway: APIHomeServiceProtocol!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        homeGateway = HomeGatewayMoke()
        homeVM = HomeViewModel(homeGetway: homeGateway)
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFeatchPhotes() {
        homeVM.initProfile()
        XCTAssert(homeVM.images?.count == 3)
    }
    
    func testImageCount() {
        XCTAssert(homeVM.getImagesCount() == 0)
        homeVM.initProfile()
        XCTAssert(homeVM.getImagesCount() == 3)
    }

    func testImageData() {
        homeVM.initProfile()
        XCTAssert(homeVM.images?[0].ownerName == "user1")
        XCTAssert(homeVM.images?[1].ownerName == "user2")
        XCTAssert(homeVM.images?[2].imgUrl == "img2")
    }
}

class HomeGatewayMoke: APIHomeServiceProtocol{
    
    func getHomeImages(complete: @escaping ([UserImages], String?) -> ()) {
        var imgs = [UserImages]()
        
        imgs.append(UserImages(id: "1", ownerId: "1", imgUrl: "img1", sharing: true, ownerName: "user1", ownerImg: "zzz"))
        
        imgs.append(UserImages(id: "2", ownerId: "1", imgUrl: "imgx", sharing: true, ownerName: "user2", ownerImg: "zzz"))
        
        imgs.append(UserImages(id: "3", ownerId: "1", imgUrl: "img2", sharing: true, ownerName: "user1", ownerImg: "yyyyy"))
        complete(imgs, nil)
    }
    
    
}
