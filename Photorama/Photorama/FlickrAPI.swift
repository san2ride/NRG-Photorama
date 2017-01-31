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

struct FlickrAPI {
    
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let APIKey = "6bbd2c01665f0c3344bdcd027d56bf9a"
    private static let APISecret = "d22b5337a3ec0019"
    
    private static func flickrURL(method: Method, parameters: [String:String]?) -> NSURL {
        
        let components = NSURLComponents(string: baseURLString)!
        
        var queryItems = [NSURLQueryItem]()
        
        let baseParams = [
            "method": method.rawValue,
            "format": "json",
            "nojsoncallback": "1",
            "api_key": APIKey,
            "api_secret": APISecret
        ]
        
        for (key, value) in baseParams {
            
            let item = NSURLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParams = parameters {
            
            for (key, value) in additionalParams {
                
                let item = NSURLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
            
        }
        components.queryItems = queryItems as [URLQueryItem]?
        
        return components.url! as NSURL
    }
    
    static func recentPhotosURL() -> NSURL {
        return flickrURL(method: .RecentPhotos, parameters: ["extras": "url_h,date_taken"])
    }
    
    
}

