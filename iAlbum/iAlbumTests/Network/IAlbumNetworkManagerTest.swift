//
//  IAlbumNetworkManagerTest.swift
//  iAlbumTests
//
//  Created by Carlos Osejo on 22/8/22.
//

import XCTest
@testable import iAlbum

class IAlbumNetworkManagerTest: XCTestCase {
    
    let responsePageOneFilename = "SuccessGetPhotosPageOne"
    let responseEmptyArrayFilename = "SuccessGetPhotosEmptyArray"
    let expectationDescription = "Network Response"
    let getPhotosIndex = 0
    let getPhotosLimit = 21
    let expectationTimeout = 1.0
    
    var networkManager: IAlbumNetworkManager!
    var expectation: XCTestExpectation!
    var networkManagerURL: URL!
    
    //MARK: Setup
    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        
        networkManager = IAlbumNetworkManager(urlSession: urlSession)
        networkManagerURL = Endpoint.getPhotos(index: getPhotosIndex, limit: getPhotosLimit).getURLRequest().url!
        expectation = expectation(description: expectationDescription)
    }
    
    //MARK: Utils
    func loadPhotosResponseData(filename: String) -> Data? {
        do {
            return try getData(fromJSON: filename)
        } catch {
            return nil
        }
    }
    
    func assertFailureResponse(_ error: Error?, _ photos: [Photo]?) {
        assert(error == nil)
        assert(photos == nil)
        self.expectation.fulfill()
    }
    
    /**
     * Configure the response to fail with the statusCode provided
     */
    func givenGetPhotoWillFail(statusCode: Int) {
        let data = Data()
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.networkManagerURL, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
    }
    
    /**
     * Configure the response to suceed returning the data stored in the dataFilename
     */
    func givenGetPhotoWillSucceed(filename: String) {
        let data = loadPhotosResponseData(filename: filename)
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url, url == self.networkManagerURL else {
                return(HTTPURLResponse(url: self.networkManagerURL, statusCode: 500, httpVersion: nil, headerFields: nil)!, nil)
            }
            
            let response = HTTPURLResponse(url: self.networkManagerURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
    }
    
    //MARK: Tests
    
    func testGetPhotosSuccessfulResponse() {
        givenGetPhotoWillSucceed(filename: responsePageOneFilename)
        
        networkManager.getPhotos(index: getPhotosIndex, limit: getPhotosLimit) { photos, error in
            assert(error == nil)
            assert(photos != nil)
            assert(photos!.count == self.getPhotosLimit)
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: expectationTimeout)
    }
    
    func testGetPhotosSuccessfulResponseEmptyArray() {
        givenGetPhotoWillSucceed(filename: responseEmptyArrayFilename)
        
        networkManager.getPhotos(index: getPhotosIndex, limit: getPhotosLimit) { photos, error in
            assert(error == nil)
            assert(photos != nil)
            assert(photos!.isEmpty)
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: expectationTimeout)
    }
    
    func testGetPhotosSuccessfulResponseWithError() {
        givenGetPhotoWillFail(statusCode: 200)
        
        networkManager.getPhotos(index: getPhotosIndex, limit: getPhotosLimit) { photos, error in
            assert(error != nil)
            assert(photos == nil)
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: expectationTimeout)
    }
    
    func testGetPhotosThreeHundredFailureResponse() {
        givenGetPhotoWillFail(statusCode: 301)
        
        networkManager.getPhotos(index: getPhotosIndex, limit: getPhotosLimit) { photos, error in
            self.assertFailureResponse(error, photos)
        }
        
        wait(for: [expectation], timeout: expectationTimeout)
    }
    
    func testGetPhotosFourHundredFailureResponse() {
        givenGetPhotoWillFail(statusCode: 404)
        
        networkManager.getPhotos(index: getPhotosIndex, limit: getPhotosLimit) { photos, error in
            self.assertFailureResponse(error, photos)
        }
        
        wait(for: [expectation], timeout: expectationTimeout)
    }
    
    func testGetPhotosFiveHundredFailureResponse() {
        givenGetPhotoWillFail(statusCode: 500)
        
        networkManager.getPhotos(index: getPhotosIndex, limit: getPhotosLimit) { photos, error in
            self.assertFailureResponse(error, photos)
        }
        
        wait(for: [expectation], timeout: expectationTimeout)
    }
}
