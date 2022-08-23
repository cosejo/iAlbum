//
//  DownloadableImageViewPresenterTest.swift
//  iAlbumTests
//
//  Created by Carlos Osejo on 23/8/22.
//

import XCTest
@testable import iAlbum

class DownloadableImageViewPresenterTest: XCTestCase {

    var mockView: DownloadableImageViewMock!
    var presenter: DownloadableImageViewPresenter!
    var mockNetworkManager: MockNetworkManager!
    
    //MARK: Setup
    override func setUp() {
        mockView = DownloadableImageViewMock()
    }
    
    //MARK: Utils
    func giveDownloadImageWillSuccess() {
        mockNetworkManager = MockNetworkManager(result: .success, data: Data())
        presenter = DownloadableImageViewPresenter(view: mockView, networkManager: mockNetworkManager)
    }
    
    func giveDownloadImageWillFail() {
        mockNetworkManager = MockNetworkManager(result: .failure, data: nil)
        presenter = DownloadableImageViewPresenter(view: mockView, networkManager: mockNetworkManager)
    }
    
    //MARK: Tests
    func testDownloadImageSuccessful() {
        giveDownloadImageWillSuccess()
        
        presenter.downloadImage(NetworkConstants.baseURLPath)
        
        assert(mockView.isImageShown)
    }
    
    func testDownloadImageFailure() {
        giveDownloadImageWillFail()
        
        presenter.downloadImage(NetworkConstants.baseURLPath)
        
        assert(!mockView.isImageShown)
    }
    
    func testDownloadImageFailureBadUrl() {
        giveDownloadImageWillFail()
        
        presenter.downloadImage("")
        
        assert(!mockView.isImageShown)
    }
    
    func testCancelLoadingImage() {
        giveDownloadImageWillSuccess()
        presenter.downloadImage(NetworkConstants.baseURLPath)
        
        presenter.cancelLoadingImage()
        
        assert(mockNetworkManager.isLoadingCancelled)
    }
}
