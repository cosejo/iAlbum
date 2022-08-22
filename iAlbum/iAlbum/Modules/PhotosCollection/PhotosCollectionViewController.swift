//
//  ViewController.swift
//  iAlbum
//
//  Created by Carlos Osejo on 20/8/22.
//

import UIKit

class PhotosCollectionViewController: UICollectionViewController {
    
    private enum StringConstants {
      static let loadingMessage = "photos.collection.loading.message"
      static let errorViewTitle = "photos.collection.error.title"
      static let errorViewMessage = "photos.collection.error.message"
      static let errorViewButton = "photos.collection.error.button"
    }
    
    private let reuseIdentifier = "PhotoCell"
    
    public var presenter: PhotosCollectionContractPresenter?
    public var photos: [Photo] = []
    public var alert: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLoadingView()
        presenter = PhotosCollectionPresenter(view: self)
        presenter?.loadPhotos()
    }
    
    func initLoadingView() {
        alert = UIAlertController(title: nil, message: StringConstants.loadingMessage.localized, preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating()
        alert?.view.addSubview(loadingIndicator)
    }
}

// MARK: - UICollectionViewDataSource
extension PhotosCollectionViewController: PhotosCollectionContractView {
    
    func showLoading() {
        present(alert!, animated: true, completion: nil)
    }
    
    func dismissLoading() {
        alert?.dismiss(animated: true, completion: nil)
    }
    
    func showError() {
        let errorAlert = UIAlertController(title: StringConstants.errorViewTitle.localized, message: StringConstants.errorViewMessage.localized, preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: StringConstants.errorViewButton.localized, style: .default, handler: nil))
        present(errorAlert, animated: true, completion: nil)
    }
    
    func updatePhotosCollection(newPhotos: [Photo]) {
        self.photos.append(contentsOf: newPhotos)
        self.collectionView.reloadData()
    }
    
}

// MARK: - UICollectionViewDataSource
extension PhotosCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCell
        cell.setCellInformation(url: photos[indexPath.row].url)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PhotosCollectionViewController {
    
}
