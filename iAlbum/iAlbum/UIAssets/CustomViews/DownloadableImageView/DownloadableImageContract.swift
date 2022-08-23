//
//  DownloadableImageContract.swift
//  iAlbum
//
//  Created by Carlos Osejo on 23/8/22.
//

import Foundation

protocol DownloadableImageContractView {
    func showImage(data: Data, url: String)
}

protocol DownloadableImageContractPresenter {
    func downloadImage(_ urlString: String)
    func cancelLoadingImage()
}
