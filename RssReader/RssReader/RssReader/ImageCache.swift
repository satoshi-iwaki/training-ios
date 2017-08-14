//
//  ImageCache.swift
//  RssReader
//
//  Created by Iwaki Satoshi on 2017/08/02.
//  Copyright © 2017年 Satoshi Iwaki. All rights reserved.
//

import UIKit

class ImageCache: NSObject, NSCacheDelegate {
    static let sharedInstance = ImageCache()
    
    private let cache = NSCache<NSString, UIImage>()
    private let defaultImage = UIImage(named: "NoImage")!
    private let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue:OperationQueue.main)
    private let queue = OperationQueue()
    
    override init() {
        super.init()
        cache.countLimit = 50
        cache.delegate = self
        queue.maxConcurrentOperationCount = 1
    }
    
    deinit {
        session.invalidateAndCancel()
        queue.cancelAllOperations()
        queue.waitUntilAllOperationsAreFinished()
    }
    
    func cachedImage(url: URL) -> UIImage? {
        guard let image = cache.object(forKey: url.absoluteString as NSString) else {
            return nil
        }
        return image
    }
    
    func getImage(url: URL, completionHandler: @escaping (UIImage?) -> Void) {
        queue.addOperation {
            if let image = self.cachedImage(url: url) {
                DispatchQueue.main.async {
                    print("*** Cached Image = %@", url)
                    completionHandler(image)
                }
                return
            }
            let semaphore = DispatchSemaphore(value: 0)
            DispatchQueue.global().async {
                let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60.0)
                self.session.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        print("error = \(error)");
                        completionHandler(nil)
                        semaphore.signal()
                        return
                    }
                    guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                        print("HTTP response is nil or data is nil")
                        completionHandler(nil)
                        semaphore.signal()
                        return
                    }
                    guard httpResponse.statusCode == 200 else {
                        print("HTTP response code is not 200")
                        completionHandler(nil)
                        semaphore.signal()
                        return
                    }
                    guard let image = UIImage(data: data) else {
                        print("HTTP response data is not image")
                        completionHandler(nil)
                        semaphore.signal()
                        return
                    }
                    self.cache.setObject(image, forKey: url.absoluteString as NSString)
                    completionHandler(image)
                    semaphore.signal()
                }.resume()
                print(">>> Start Download Image = %@", url)
            }
            semaphore.wait()
            print("<<< End   Download Image = %@", url)
        }
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
}

extension UIImageView {
    func setImage(url: URL) {
        if let image = ImageCache.sharedInstance.cachedImage(url: url) {
            self.image = image
            return
        }
        
        ImageCache.sharedInstance.getImage(url: url) { (image: UIImage?) in
            guard let image = image else {
                self.image = UIImage(named:"NoImage.png")
                return
            }
            
            self.image = image
            self.setNeedsLayout()
            self.setNeedsDisplay()
        }
    }
}

