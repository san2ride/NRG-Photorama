//
//  Photo.swift
//  Photorama
//
//  Created by don't touch me on 1/31/17.
//  Copyright © 2017 trvl, LLC. All rights reserved.
//

import Foundation

class Photo {
    
    let title: String
    let remoteURL: NSURL
    let photoID: String
    let dateTaken: NSDate
    
    init(title: String, photoID: String, remoteURL: NSURL, dateTaken: NSDate) {
        self.title = title
        self.photoID = photoID
        self.remoteURL = remoteURL
        self.dateTaken = dateTaken
    }
}
