//
//  RssReaderTests.swift
//  RssReaderTests
//
//  Created by Iwaki Satoshi on 2017/07/26.
//  Copyright © 2017年 Satoshi Iwaki. All rights reserved.
//

import XCTest
@testable import RssReader

class RssReaderTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoad() {
        class TestRssReaderDelegate: RssReaderDelegate {
            var rss: Rss?
            var error: Error?
            let expectation: XCTestExpectation
            init(expectation: XCTestExpectation) {
                self.expectation = expectation
            }
            func didFinishLoading(rssReader: RssReader, rss: Rss?, error: Error?) -> Void {
                expectation .fulfill()
                self.rss = rss
                self.error = error
            }
        }
        let expectation = XCTestExpectation()
        let delegate = TestRssReaderDelegate(expectation: expectation);

        let url = URL(string: "https://rss.applemarketingtools.com/api/v2/us/music/most-played/10/albums.json")!
        let rssReader = RssReader()
        rssReader.delegate = delegate;

        rssReader.load(url: url)
        self.wait(for: [expectation], timeout: 120)

        XCTAssertNotNil(delegate.rss)
        XCTAssertNil(delegate.error)
    }
    
    func testDecode() {
        let json = """
        {
          "feed": {
            "title": "Top Albums",
            "id": "https://rss.applemarketingtools.com/api/v2/us/music/most-played/10/albums.json",
            "author": {
              "name": "Apple",
              "url": "https://www.apple.com/"
            },
            "links": [
              {
                "self": "https://rss.applemarketingtools.com/api/v2/us/music/most-played/10/albums.json"
              }
            ],
            "copyright": "Copyright © 2022 Apple Inc. All rights reserved.",
            "country": "us",
            "icon": "https://www.apple.com/favicon.ico",
            "updated": "Wed, 27 Jul 2022 14:38:12 +0000",
            "results": [
              {
                "artistName": "Bad Bunny",
                "id": "1622045624",
                "name": "Un Verano Sin Ti",
                "releaseDate": "2022-05-06",
                "kind": "albums",
                "artistId": "1126808565",
                "artistUrl": "https://music.apple.com/us/artist/bad-bunny/1126808565",
                "contentAdvisoryRating": "Explict",
                "artworkUrl100": "https://is5-ssl.mzstatic.com/image/thumb/Music112/v4/3e/04/eb/3e04ebf6-370f-f59d-ec84-2c2643db92f1/196626945068.jpg/100x100bb.jpg",
                "genres": [
                  {
                    "genreId": "12",
                    "name": "Latin",
                    "url": "https://itunes.apple.com/us/genre/id12"
                  },
                  {
                    "genreId": "34",
                    "name": "Music",
                    "url": "https://itunes.apple.com/us/genre/id34"
                  }
                ],
                "url": "https://music.apple.com/us/album/un-verano-sin-ti/1622045624"
              },
              {
                "artistName": "Lil Uzi Vert",
                "id": "1636044348",
                "name": "RED & WHITE - EP",
                "releaseDate": "2022-07-22",
                "kind": "albums",
                "artistId": "940710524",
                "artistUrl": "https://music.apple.com/us/artist/lil-uzi-vert/940710524",
                "contentAdvisoryRating": "Explict",
                "artworkUrl100": "https://is5-ssl.mzstatic.com/image/thumb/Music122/v4/30/73/0e/30730e80-a174-80f6-5428-36223ca1b222/075679732644.jpg/100x100bb.jpg",
                "genres": [
                  {
                    "genreId": "18",
                    "name": "Hip-Hop/Rap",
                    "url": "https://itunes.apple.com/us/genre/id18"
                  },
                  {
                    "genreId": "34",
                    "name": "Music",
                    "url": "https://itunes.apple.com/us/genre/id34"
                  }
                ],
                "url": "https://music.apple.com/us/album/red-white-ep/1636044348"
              }
            ]
          }
        }
        """.data(using: .utf8)!
        let rssReader = RssReader()
        
        do {
            let rss = try rssReader.decode(data: json)
            XCTAssertNotNil(rss)
            XCTAssertEqual(rss.feed.title, "Top Albums")
            XCTAssertEqual(rss.feed.id, "https://rss.applemarketingtools.com/api/v2/us/music/most-played/10/albums.json")
            XCTAssertEqual(rss.feed.author.name, "Apple")
            XCTAssertEqual(rss.feed.author.url.absoluteString, "https://www.apple.com/")
            XCTAssertEqual(rss.feed.links.count, 1)
            XCTAssertEqual(rss.feed.links[0]["self"], "https://rss.applemarketingtools.com/api/v2/us/music/most-played/10/albums.json")
            XCTAssertEqual(rss.feed.copyright, "Copyright © 2022 Apple Inc. All rights reserved.")
            XCTAssertEqual(rss.feed.country, "us")
            XCTAssertEqual(rss.feed.icon.absoluteString, "https://www.apple.com/favicon.ico")
            XCTAssertEqual(rss.feed.updated.timeIntervalSince1970, 1658932692.0) // "2017-08-12T01:30:53.000-07:00"
            XCTAssertEqual(rss.feed.results.count, 2)
            XCTAssertEqual(rss.feed.results[0].artistId, "1126808565")
            XCTAssertEqual(rss.feed.results[0].artistName, "Bad Bunny")
            XCTAssertEqual(rss.feed.results[0].artistUrl?.absoluteString, "https://music.apple.com/us/artist/bad-bunny/1126808565")
            XCTAssertEqual(rss.feed.results[0].artworkUrl100.absoluteString, "https://is5-ssl.mzstatic.com/image/thumb/Music112/v4/3e/04/eb/3e04ebf6-370f-f59d-ec84-2c2643db92f1/196626945068.jpg/100x100bb.jpg")
            XCTAssertEqual(rss.feed.results[0].genres.count, 2)
            XCTAssertEqual(rss.feed.results[0].genres[0].genreId, "12")
            XCTAssertEqual(rss.feed.results[0].genres[0].name, "Latin")
            XCTAssertEqual(rss.feed.results[0].genres[0].url.absoluteString, "https://itunes.apple.com/us/genre/id12")
            XCTAssertEqual(rss.feed.results[0].genres[1].genreId, "34")
            XCTAssertEqual(rss.feed.results[0].genres[1].name, "Music")
            XCTAssertEqual(rss.feed.results[0].genres[1].url.absoluteString, "https://itunes.apple.com/us/genre/id34")
            XCTAssertEqual(rss.feed.results[0].id, "1622045624")
            XCTAssertEqual(rss.feed.results[0].kind, "albums")
            XCTAssertEqual(rss.feed.results[0].name, "Un Verano Sin Ti")
            XCTAssertEqual(rss.feed.results[0].releaseDate, "2022-05-06")
            XCTAssertEqual(rss.feed.results[0].url.absoluteString, "https://music.apple.com/us/album/un-verano-sin-ti/1622045624")
            XCTAssertEqual(rss.feed.results[1].artistId, "940710524")
            XCTAssertEqual(rss.feed.results[1].artistName, "Lil Uzi Vert")
            XCTAssertEqual(rss.feed.results[1].artistUrl?.absoluteString, "https://music.apple.com/us/artist/lil-uzi-vert/940710524")
            XCTAssertEqual(rss.feed.results[1].artworkUrl100.absoluteString, "https://is5-ssl.mzstatic.com/image/thumb/Music122/v4/30/73/0e/30730e80-a174-80f6-5428-36223ca1b222/075679732644.jpg/100x100bb.jpg")
            XCTAssertEqual(rss.feed.results[1].genres.count, 2)
            XCTAssertEqual(rss.feed.results[1].genres[0].genreId, "18")
            XCTAssertEqual(rss.feed.results[1].genres[0].name, "Hip-Hop/Rap")
            XCTAssertEqual(rss.feed.results[1].genres[0].url.absoluteString, "https://itunes.apple.com/us/genre/id18")
            XCTAssertEqual(rss.feed.results[1].genres[1].genreId, "34")
            XCTAssertEqual(rss.feed.results[1].genres[1].name, "Music")
            XCTAssertEqual(rss.feed.results[1].genres[1].url.absoluteString, "https://itunes.apple.com/us/genre/id34")
            XCTAssertEqual(rss.feed.results[1].id, "1636044348")
            XCTAssertEqual(rss.feed.results[1].kind, "albums")
            XCTAssertEqual(rss.feed.results[1].name, "RED & WHITE - EP")
            XCTAssertEqual(rss.feed.results[1].releaseDate, "2022-07-22")
            XCTAssertEqual(rss.feed.results[1].url.absoluteString, "https://music.apple.com/us/album/red-white-ep/1636044348")
        } catch {
            XCTFail()
        }
    }
}
