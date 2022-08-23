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
    let mockUrlString = "https://via.placeholder.com/600/92c952"
    let cancelledTaskErrorMessage = "cancelled"
    let cancelledTaskErrorCode = -999
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
     * Configure the response to suceed returning the data stored in the dataFilename
     */
    func givenGetPhotoWillSucceed(filename: String) {
        let data = loadPhotosResponseData(filename: filename)
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.networkManagerURL, statusCode: NetworkConstants.successfulResponseCode, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
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
     * Configure the response to suceed returning the data
     */
    func givenDownloadImageWillSucceed() {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.networkManagerURL, statusCode: NetworkConstants.successfulResponseCode, httpVersion: nil, headerFields: [NetworkConstants.contentHeaderKey : NetworkConstants.imageMimeType])!
            return (response, Data())
        }
    }
    
    /**
     * Configure the response to suceed returning the data
     */
    func givenDownloadImageWillFail(statusCode: Int, data: Data? = Data(), mimeType: String = "") {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.networkManagerURL, statusCode: statusCode, httpVersion: nil, headerFields: [NetworkConstants.contentHeaderKey : mimeType])!
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
        givenGetPhotoWillFail(statusCode: NetworkConstants.successfulResponseCode)
        
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
    
    func testDownloadImageSuccessfulResponse() {
        givenDownloadImageWillSucceed()
        
        networkManager.downloadImage(URL(string: mockUrlString)!) { data, error in
            assert(error == nil)
            assert(data != nil)
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: expectationTimeout)
    }
    
    func testDownloadImageFailureNoDataResponse() {
        givenDownloadImageWillFail(statusCode: NetworkConstants.successfulResponseCode, data: nil, mimeType: NetworkConstants.imageMimeType)
        
        networkManager.downloadImage(URL(string: mockUrlString)!) { data, error in
            assert(error == nil)
            assert(data != nil)
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: expectationTimeout)
    }
    
    func testDownloadImageFailureWrongMimeTypeResponse() {
        givenDownloadImageWillFail(statusCode: NetworkConstants.successfulResponseCode)
        
        networkManager.downloadImage(URL(string: mockUrlString)!) { data, error in
            assert(error == nil)
            assert(data == nil)
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: expectationTimeout)
    }
    
    func testDownloadImageFailureFiveHundredResponse() {
        givenDownloadImageWillFail(statusCode: 500)
        
        networkManager.downloadImage(URL(string: mockUrlString)!) { data, error in
            assert(error == nil)
            assert(data == nil)
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: expectationTimeout)
    }
    
    func testCancelLoadingImageResponse() {
        givenDownloadImageWillSucceed()
        
        networkManager.downloadImage(URL(string: mockUrlString)!) { data, error in
            assert(data == nil)
            assert(error!.localizedDescription.elementsEqual(self.cancelledTaskErrorMessage))
            assert((error! as NSError).code == self.cancelledTaskErrorCode)
            self.expectation.fulfill()
        }
        
        networkManager.cancelLoadingImage()
        XCTAssertNil(networkManager.task)
        wait(for: [expectation], timeout: expectationTimeout)
    }
}
