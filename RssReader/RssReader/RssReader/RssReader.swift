//
//  RssReader.swift
//  RssReader
//
//  Created by Iwaki Satoshi on 2017/07/31.
//  Copyright © 2017年 Satoshi Iwaki. All rights reserved.
//

import UIKit



protocol RssReaderDelegate : class {
    func didFinishLoading(rssReader: RssReader, rss: Rss?, error: Error?) -> Void
}

class RssReader: NSObject, URLSessionDelegate {
    weak var delegate: RssReaderDelegate?
    var rss: Rss?

    private let _session: URLSession
    override public init() {
        _session = URLSession(configuration: URLSessionConfiguration.default,
                              delegate: nil, delegateQueue: nil)
        super.init()
    }
    
    func load(url: URL) {
        let task = _session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("error = \(error)");
                self.delegate?.didFinishLoading(rssReader: self, rss: nil, error: error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                print("HTTP response is nil or data is nil")
                return
            }
            guard httpResponse.statusCode == 200 else {
                print("HTTP response code is not 200")
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
    
    func decode(data: Data) throws -> Rss {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"   // "2017-07-28T00:00:00Z"
//        let decoder: JSONDecoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .formatted(formatter)
        let decoder: JSONDecoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            let rss = try decoder.decode(Rss.self, from: data)
            print(rss)
            return rss
        } catch {
            print(error)
            throw(error)
        }
    }
}
