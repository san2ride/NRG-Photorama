//
//  PhotoStore.swift
//  Photorama
//
//  Created by don't touch me on 1/30/17.
//  Copyright © 2017 trvl, LLC. All rights reserved.
//

import Foundation

class PhotoStore {
    
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    // Spawns a URL request tasks. This tasks will will take in a URL request,
    // when it asynchronously retrieves the URL data. It will process the json
    // body via processReccentPhotoRequest. It will then pass the results of this
    // as an argument to a closure as a PhotoResults.
    func fetchRecentPhotos(completion: @escaping (PhotosResult) -> Void) {
        
        let url = FlickrAPI.recentPhotosURL()
        let request = URLRequest(url: url as URL)
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            let result = self.processRecentPhotosRequest(data: data, error: error as NSError?)
            completion(result)
        })
        task.resume()
    }
    // This takes in data from a url request and uses the flicker API to transform it
    // into a PhotoResult.
    func processRecentPhotosRequest(data: Data?, error: NSError?) -> PhotosResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        
        return FlickrAPI.photosFromJSONData(jsonData)
    }
}
