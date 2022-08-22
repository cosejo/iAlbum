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
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    public var presenter: PhotosCollectionContractPresenter?
    public var activityIndicator: UIActivityIndicatorView?
    public var refreshControl: UIRefreshControl?
    public var photos: [Photo] = []
    public var isLoading: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLoadingView()
        setupRefreshingGesture()
        initPresenter()
        loadPhotos()
    }
    
    func initLoadingView() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        view.addSubview(activityIndicator!)
        activityIndicator?.frame = view.bounds
        activityIndicator?.startAnimating()
    }
    
    func setupRefreshingGesture() {
        refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl!.addTarget(self, action: #selector(PhotosCollectionViewController.loadMorePhotos), for: .valueChanged)
        collectionView.addSubview(refreshControl!)
    }
    
    func initPresenter() {
        presenter = PhotosCollectionPresenter(view: self)
    }
    
    func loadPhotos() {
        presenter?.loadPhotos()
    }
    
    @objc func loadMorePhotos() {
        guard !isLoading else {
            refreshControl?.endRefreshing()
            return
        }
        
        presenter?.reloadPhotos()
    }
}

// MARK: - UICollectionViewDataSource
extension PhotosCollectionViewController: PhotosCollectionContractView {
    
    func showLoading() {
        isLoading = true
        refreshControl?.endRefreshing()
        activityIndicator?.startAnimating()
    }
    
    func dismissLoading() {
        isLoading = false
        activityIndicator?.stopAnimating()
    }
    
    func showError() {
        let errorAlert = UIAlertController(title: StringConstants.errorViewTitle.localized, message: StringConstants.errorViewMessage.localized, preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: StringConstants.errorViewButton.localized, style: .default, handler: nil))
        present(errorAlert, animated: true, completion: nil)
    }
    
    func updatePhotosCollection(newPhotos: [Photo], isReload: Bool) {
        if isReload {
            photos = newPhotos
        } else {
            photos.append(contentsOf: newPhotos)
        }
        
        collectionView.reloadData()
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
    
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == photos.count-1 && !isLoading  {
            loadPhotos()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension PhotosCollectionViewController {
}

// MARK: - Collection View Flow Layout Delegate
extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}
