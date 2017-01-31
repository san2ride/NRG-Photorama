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
        
        store.fetchRecentPhotos()
    }
        
        
        
    

    
    

    

}
