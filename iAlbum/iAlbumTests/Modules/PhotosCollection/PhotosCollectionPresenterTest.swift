//
//  iAlbumTests.swift
//  iAlbumTests
//
//  Created by Carlos Osejo on 20/8/22.
//

import XCTest
@testable import iAlbum

class PhotosCollectionPresenterTest: XCTestCase {
    
    let responsePageOneFilename = "SuccessGetPhotosPageOne"
    let responsePageTwoFilename = "SuccessGetPhotosPageTwo"
    let responseDoublePageilename = "SuccessGetPhotosDoublePage"

    var mockView: PhotosCollectionViewMock!
    var presenter: PhotosCollectionPresenter!
    var mockNetworkManager: MockNetworkManager!
    var photosResponse: [Photo]!
    
    //MARK: Setup
    override func setUp() {
        mockView = PhotosCollectionViewMock()
    }
    
    override func tearDown() {
        photosResponse = []
    }
    
    func loadPhotosResponseData(filename: String) {
        do {
            let data = try getData(fromJSON: filename)
            photosResponse = try JSONDecoder().decode([Photo].self, from: data)
        } catch {
            photosResponse = []
        }
    }
    
    func setupPresenter(result: ResponseResult) {
        mockNetworkManager = MockNetworkManager(result: result, photosResponse: photosResponse)
        presenter = PhotosCollectionPresenter(view: mockView, networkManager: mockNetworkManager)
    }
    
    //MARK: Utils
    
    /**
     * Configure the Network Manager to respond successfully the request with the page one file
     */
    func givenGetPhotosPageOnceWillSucceed() {
        loadPhotosResponseData(filename: responsePageOneFilename)
        setupPresenter(result: .success)
    }
    
    /**
     * Configure the Network Manager to respond successfully the request with the page one, load photos and then respond successfully the next request with the page two file
     */
    func givenGetPhotosPageTwoWillSucceed() {
        givenGetPhotosPageOnceWillSucceed()
        presenter.loadPhotos()
        loadPhotosResponseData(filename: responsePageTwoFilename)
        mockNetworkManager.photosResponse = photosResponse
    }
    
    /**
     * Configure the Network Manager to respond successfully both of the requests  with the page one and two, load photos and then respond successfully the next request with the double page file
     */
    func givenGetPhotosPageTwoAndReloadWillSucceed() {
        givenGetPhotosPageOnceWillSucceed()
        presenter.loadPhotos()
        loadPhotosResponseData(filename: responsePageTwoFilename)
        mockNetworkManager.photosResponse = photosResponse
        presenter.loadPhotos()
        loadPhotosResponseData(filename: responseDoublePageilename)
        mockNetworkManager.photosResponse = photosResponse
    }
    
    func testLoadPhotosSuccessfulPageOnce() {
        givenGetPhotosPageOnceWillSucceed()
        
        presenter.loadPhotos()
        
        assert(!mockView.isReload)
        assert(mockView.photos.count == presenter.photos.count)
        assert(mockView.photos.count == presenter.photosLimit)
    }
    
    //MARK: Tests
    
    func testLoadPhotosSuccessfulPageTwo() {
        givenGetPhotosPageTwoWillSucceed()
        
        presenter.loadPhotos()
        
        assert(!mockView.isReload)
        assert(mockView.photos.count == presenter.photos.count)
        assert(mockView.photos.count > presenter.photosLimit)
    }
    
    func testLoadPhotosErrorResponse() {
        setupPresenter(result: .failure)
        
        presenter.loadPhotos()
        
        assert(mockView.isErrorShown)
        assert(mockView.photos.isEmpty)
        assert(mockView.photos.count == presenter.photos.count)
    }
    
    func testReloadPhotosSucessful() {
        givenGetPhotosPageTwoAndReloadWillSucceed()
        
        presenter.reloadPhotos()
        
        assert(mockView.isReload)
        assert(mockView.photos.count == presenter.photos.count)
        assert(mockView.photos.count == presenter.photosLimit * 2)
    }
    
    func testSelectPhoto() {
        let selectedPhotoIndex = 5
        givenGetPhotosPageOnceWillSucceed()
        let expectedPhoto = photosResponse[selectedPhotoIndex]
        presenter.loadPhotos()
        
        presenter.selectPhoto(selectedPhotoIndex)
        
        assert(mockView.isDetailOpen)
        assert(mockView.thumbnailUrl.elementsEqual(expectedPhoto.thumbnailUrl))
    }
    
}
