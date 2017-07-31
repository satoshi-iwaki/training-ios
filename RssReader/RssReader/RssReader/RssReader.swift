//
//  RssReader.swift
//  RssReader
//
//  Created by Iwaki Satoshi on 2017/07/31.
//  Copyright © 2017年 Satoshi Iwaki. All rights reserved.
//

import UIKit



protocol RssReaderDelegate : class {
    func didLoad(rssReader: RssReader) -> Void
}

class RssReader: NSObject, URLSessionDelegate {
    weak var delegate: RssReaderDelegate?
    let feeds: [RssFeed] = []

    private let url: URL
    private let session: URLSession
    public init(url: URL) {
        self.url = url;
        self.session = URLSession(configuration: URLSessionConfiguration.default,
                                 delegate: self, delegateQueue: nil)
    }
    
    func load() {
        session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                return;
            }
            
            guard let httpResponse: HTTPURLResponse = response as! HTTPURLResponse else {
            }
            switch
            httpResponse.statusCode
            guard let jsonData = data else {
                
            }
            self.decode(data: jsonData)
        }
    }
    
    private func decode(data: Data) -> RssFeed {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let decoder: JSONDecoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        do {
            let a = try decoder.decode(RssFeed.self, from: data)
            print(a)
        } catch {
            print(error)
        }
    }
}
