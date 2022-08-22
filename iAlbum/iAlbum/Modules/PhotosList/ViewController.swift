//
//  ViewController.swift
//  iAlbum
//
//  Created by Carlos Osejo on 20/8/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        IAlbumNetworkManager().getPhotos(index: 0, limit: 20) { photosList, error in
            print("asdf")
        }
    }
}

