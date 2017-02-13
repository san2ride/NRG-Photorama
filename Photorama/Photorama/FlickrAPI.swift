//
//  FlickrAPI.swift
//  Photorama
//
//  Created by don't touch me on 1/30/17.
//  Copyright © 2017 trvl, LLC. All rights reserved.
//

import Foundation

enum Method: String {
    case RecentPhotos = "flickr.photos.getRecent"
}

enum PhotosResult {
    case success([Photo])
    case failure(Error)
}

enum FlickrError: Error {
    case invalidJSONData
}

struct FlickrAPI {
    
    fileprivate static let baseURLString = "https://api.flickr.com/services/rest"
    fileprivate static let APIKey = "a6d819499131071f158fd740860a5a88"
//    fileprivate static let APISecret = "d22b5337a3ec0019"
    
    fileprivate static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    fileprivate static func flickrURL(method: Method, parameters: [String:String]?) -> URL {
        
        var components = URLComponents(string: baseURLString)!
        
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "method": method.rawValue,
            "format": "json",
            "nojsoncallback": "1",
            "api_key": APIKey,
//            "api_secret": APISecret
        ]
        
        for (key,value) in baseParams {
            
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        
        components.queryItems = queryItems
        return components.url!
    }
    
    static func recentPhotosURL() -> URL {
        return flickrURL(method: Method.RecentPhotos, parameters: ["extras": "url_h,date_taken"])
    }
    
    fileprivate static func photoFromJSONObject(json: [String : AnyObject]) -> Photo? {
        
        guard let
            photoID = json["id"] as? String,
            let title = json["title"] as? String,
            let dateString = json["dateTaken"] as? String,
            let photoURLString = json["url_h"] as? String,
            let url = URL(string: photoURLString),
            let dateTaken = dateFormatter.date(from: dateString) else {
            
                return nil
        }
        return Photo(title: title, photoID: photoID, remoteURL: url, dateTaken: dateTaken)
    }
    
    static func photosFromJSONData(_ data: Data) -> PhotosResult {
        
        do {
            let jsonObject: Any
                    = try JSONSerialization.jsonObject(with: data, options: [])
            // The top level json is an object
            // with a key photos, that is an an object
            // with a key photo, that is an array of objects
            // This array of objects contains a keys we are interested in to
            // get the actual image: "url_h".
            //print(NSString(data: data, encoding: NSUTF8StringEncoding)!)
            
            guard let
                jsonDictionary = jsonObject as? [AnyHashable: Any],
                let photos = jsonDictionary["photos"] as? [String:AnyObject],
                let photosArray = photos["photo"] as? [[String:AnyObject]] else {
                    
                    return .failure(FlickrError.invalidJSONData)
            }
            
            var finalPhotos = [Photo]()
            for photoJSON in photosArray {
                if let photo = photoFromJSONObject(json: photoJSON) {
                    finalPhotos.append(photo)
                }
            }
            
            if finalPhotos.count == 0 && photosArray.count > 0 {
                // We weren't able to parse any of the photos
                // Maybe the JSON format for photos has changed
                return .failure(FlickrError.invalidJSONData)
            }
            return .success(finalPhotos)
        } catch let error {
            return .failure(error)
        }
    }
}

