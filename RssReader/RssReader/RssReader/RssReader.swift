//
//  RssReader.swift
//  RssReader
//
//  Created by Iwaki Satoshi on 2017/07/31.
//  Copyright © 2017年 Satoshi Iwaki. All rights reserved.
//

import UIKit

protocol RssReaderDelegate : AnyObject {
    func didFinishLoading(rssReader: RssReader, rss: Rss?, error: Error?) -> Void
}

class RssReader: NSObject, URLSessionDelegate {
    weak var delegate: RssReaderDelegate?
    var rss: Rss?

    private let session: URLSession
    override public init() {
        session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
        super.init()
    }
    
    func load(url: URL) {
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                debugPrint("error = \(error)");
                self.delegate?.didFinishLoading(rssReader: self, rss: nil, error: error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                debugPrint("HTTP response is nil or data is nil")
                self.delegate?.didFinishLoading(rssReader: self, rss: nil, error: error)
                return
            }
            guard httpResponse.statusCode == 200 else {
                debugPrint("HTTP response code is not 200")
                self.delegate?.didFinishLoading(rssReader: self, rss: nil, error: error)
                return
            }
            
            do {
                let rss = try self.decode(data: data)
                self.rss = rss
                self.delegate?.didFinishLoading(rssReader: self, rss: self.rss, error: nil)
            } catch {
                self.delegate?.didFinishLoading(rssReader: self, rss: nil, error: error)
            }
        }
        task.resume()
    }
    
    func invalidateAndCancel() {
        session.invalidateAndCancel()
    }
    
    func decode(data: Data) throws -> Rss {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE',' dd MMM yyyy HH:mm:ss z"   // "Wed, 27 Jul 2022 14:38:12 +0000"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US")
        let decoder: JSONDecoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)

        do {
            let rss = try decoder.decode(Rss.self, from: data)
            debugPrint(rss)
            return rss
        } catch {
            debugPrint(error)
            throw(error)
        }
    }
}
