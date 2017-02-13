//
//  PhotosViewController.swift
//  Photorama
//
//  Created by don't touch me on 1/30/17.
//  Copyright © 2017 trvl, LLC. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var store: PhotoStore!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchRecentPhotos() {
            (photosResult) -> Void in
            // This block gets called once we have processed rest API
            // and receivedd a list of recent photos and their URLs
            // We then retrieved the very first image
            
            switch photosResult {
            case let .success(photos):
                print("Succesfully found \(photos.count) recent photos")
            case let .failure(error):
                print("Error fetching recent photos: \(error)")
            }
        }
    }
        
        
    
    

    

}
