//
//  RssFeed.swift
//  RssReader
//
//  Created by Iwaki Satoshi on 2017/07/26.
//  Copyright © 2017年 Satoshi Iwaki. All rights reserved.
//

import UIKit

struct RssFeedAuthor: Codable {
    let name: String
    let uri: URL
}
struct RssFeedLink: Codable {
    //    let self: URL
    let alternate: URL
}
struct RssFeed: Codable {
    let title: String
    let id: String
    let author: RssFeedAuthor
    let links: [RssFeedLink]
}
struct RssFeedItem: Codable {
    
}
