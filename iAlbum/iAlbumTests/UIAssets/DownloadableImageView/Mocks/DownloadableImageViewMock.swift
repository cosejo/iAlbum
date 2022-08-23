//
//  DownloadableImageViewMock.swift
//  iAlbumTests
//
//  Created by Carlos Osejo on 23/8/22.
//

import Foundation
@testable import iAlbum

class DownloadableImageViewMock: DownloadableImageContractView {
    
    private(set) var isImageShown = false
    
    func showImage(data: Data, url: String) {
        isImageShown = true
    }
}
