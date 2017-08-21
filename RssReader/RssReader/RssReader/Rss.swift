//
//  RssFeed.swift
//  RssReader
//
//  Created by Iwaki Satoshi on 2017/07/26.
//  Copyright © 2017年 Satoshi Iwaki. All rights reserved.
//

import UIKit

struct RssFeedResultGenre: Codable {
    let genreId: String
    let name: String
    let url: URL
}

struct RssFeedResult: Codable {
    let artistId: String
    let artistName: String
    let artistUrl: URL
    let artworkUrl100: URL
    let copyright: String?  // optional
    let genres: [RssFeedResultGenre]
    let id: String
    let kind: String
    let name: String
    let releaseDate: String
    let url: URL
}

struct RssFeedAuthor: Codable {
    let name: String
    let uri: URL
}

struct RssFeed: Codable {
    let title: String
    let id: String
    let author: RssFeedAuthor
    let links: [Dictionary<String, String>]
    let copyright: String
    let country: String
    let icon: URL
    let updated: Date
    let results: [RssFeedResult]
}

struct Rss: Codable {
    let feed: RssFeed
}

struct Bookmark: Codable {
    let title: String
    let url: URL
    var rss: Rss?

    init(title: String, url: URL) {
        self.title = title
        self.url = url
        self.rss = nil
    }
}
