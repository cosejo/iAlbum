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
        static let refreshViewTitle = "photos.collection.refresh.title"
    }
    
    private let reuseIdentifier = "PhotoCell"
    private let storyboardName = "Main"
    private let photoDetailViewControllerID = "PhotoDetailViewController"
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    public var activityIndicator: UIActivityIndicatorView?
    public var refreshControl: UIRefreshControl?
    
    public var presenter: PhotosCollectionContractPresenter?
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
        refreshControl!.attributedTitle = NSAttributedString(string: StringConstants.refreshViewTitle.localized)
        refreshControl!.addTarget(self, action: #selector(PhotosCollectionViewController.reloadPhotos), for: .valueChanged)
        collectionView.addSubview(refreshControl!)
    }
    
    func initPresenter() {
        presenter = PhotosCollectionPresenter(view: self)
    }
    
    func loadPhotos() {
        presenter?.loadPhotos()
    }
    
    @objc func reloadPhotos() {
        guard !isLoading else {
            refreshControl?.endRefreshing()
            return
        }
        
        presenter?.reloadPhotos()
    }
}

// MARK: - UICollectionViewDataSource
// Use Main Actor - wait for Swift 5.5
extension PhotosCollectionViewController: PhotosCollectionContractView {
    
    func showLoading() {
        isLoading = true
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl?.endRefreshing()
            self?.activityIndicator?.startAnimating()
        }
    }
    
    func dismissLoading() {
        isLoading = false
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator?.stopAnimating()
        }
    }
    
    func showError() {
        let errorAlert = UIAlertController(title: StringConstants.errorViewTitle.localized, message: StringConstants.errorViewMessage.localized, preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: StringConstants.errorViewButton.localized, style: .default, handler: nil))
        DispatchQueue.main.async { [weak self] in
            self?.present(errorAlert, animated: true, completion: nil)
        }
    }
    
    /**
     * Update the Collecttion, if it is a reload call it will replace the list to refresh it.
     */
    func updatePhotosCollection(newPhotos: [Photo], isReload: Bool) {
        if isReload {
            photos = newPhotos
        } else {
            photos.append(contentsOf: newPhotos)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }

    func openPhotoDetail(thumbnailUrl: String) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let photoDetailViewController: PhotoDetailViewController = storyboard.instantiateViewController(identifier: photoDetailViewControllerID)
        photoDetailViewController.photoUrl = thumbnailUrl
        show(photoDetailViewController, sender: self)
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
        if indexPath.row == photos.count - 1 && !isLoading  {
            loadPhotos()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension PhotosCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.selectPhoto(indexPath.row)
    }
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
