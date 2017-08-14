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

        let url = URL(string: "https://rss.itunes.apple.com/api/v1/us/apple-music/new-music/10/explicit.json")!
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
            "feed":{
                "title":"New Releases",
                "id":"https://rss.itunes.apple.com/api/v1/us/apple-music/new-music/2/explicit.json",
                "author":{
                    "name":"iTunes Store",
                    "uri":"http://wwww.apple.com/us/itunes/"
                },
                "links":[
                    {"self":"https://rss.itunes.apple.com/api/v1/us/apple-music/new-music/2/explicit.json"},
                    {"alternate":"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewRoom?fcId=976405703"}
                ],
                "copyright":"Copyright © 2017 Apple Inc. All Rights Reserved.",
                "country":"us",
                "icon":"http://itunes.apple.com/favicon.ico",
                "updated":"2017-08-12T01:30:53.000-07:00",
                "results":[
                    {
                        "artistId":"991187319",
                        "artistName":"Moneybagg Yo",
                        "artistUrl":"https://itunes.apple.com/us/artist/moneybagg-yo/id991187319",
                        "artworkUrl100":"http://is1.mzstatic.com/image/thumb/Music118/v4/28/25/c8/2825c846-e976-bd16-2fbf-f5bdf3334877/source/200x200bb.png",
                        "copyright":"℗ 2017 N-Less Entertainment, LLC distributed by Interscope Records",
                        "genres":[
                            {
                                "genreId":"18",
                                "name":"Hip-Hop/Rap",
                                "url":"https://itunes.apple.com/us/genre/id18"
                            },
                            {
                                "genreId":"34",
                                "name":"Music",
                                "url":"https://itunes.apple.com/us/genre/id34"
                            }
                        ],
                        "id":"1267471554",
                        "kind":"album",
                        "name":"Federal 3X",
                        "releaseDate":"2017-08-11",
                        "url":"https://itunes.apple.com/us/album/federal-3x/id1267471554"
                    },
                    {
                        "artistId":"334854763",
                        "artistName":"Kesha",
                        "artistUrl":"https://itunes.apple.com/us/artist/kesha/id334854763",
                        "artworkUrl100":"http://is1.mzstatic.com/image/thumb/Music117/v4/06/19/3e/06193ee9-3caa-642c-901c-d0097470c50b/source/200x200bb.png",
                        "copyright":"℗ 2017 Kemosabe Records",
                        "genres":[
                            {
                                "genreId":"14",
                                "name":"Pop",
                                "url":"https://itunes.apple.com/us/genre/id14"
                            },
                            {
                                "genreId":"34",
                                "name":"Music",
                                "url":"https://itunes.apple.com/us/genre/id34"
                            }
                        ],
                        "id":"1253656856",
                        "kind":"album",
                        "name":"Rainbow",
                        "releaseDate":"2017-08-11",
                        "url":"https://itunes.apple.com/us/album/rainbow/id1253656856"
                    }
                ]
            }
        }
        """.data(using: .utf8)!
        let rssReader = RssReader()
        
        do {
            let rss = try rssReader.decode(data: json)
            XCTAssertNotNil(rss)
            XCTAssertEqual(rss.feed.title, "New Releases")
            XCTAssertEqual(rss.feed.id, "https://rss.itunes.apple.com/api/v1/us/apple-music/new-music/2/explicit.json")
            XCTAssertEqual(rss.feed.author.name, "iTunes Store")
            XCTAssertEqual(rss.feed.author.uri.absoluteString, "http://wwww.apple.com/us/itunes/")
            XCTAssertEqual(rss.feed.links.count, 2)
            XCTAssertEqual(rss.feed.links[0]["self"], "https://rss.itunes.apple.com/api/v1/us/apple-music/new-music/2/explicit.json")
            XCTAssertEqual(rss.feed.links[1]["alternate"], "https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewRoom?fcId=976405703")
            XCTAssertEqual(rss.feed.copyright, "Copyright © 2017 Apple Inc. All Rights Reserved.")
            XCTAssertEqual(rss.feed.country, "us")
            XCTAssertEqual(rss.feed.icon.absoluteString, "http://itunes.apple.com/favicon.ico")
            XCTAssertEqual(rss.feed.updated.timeIntervalSince1970, 1502526653.0) // "2017-08-12T01:30:53.000-07:00"
            XCTAssertEqual(rss.feed.results.count, 2)
            XCTAssertEqual(rss.feed.results[0].artistId, "991187319")
            XCTAssertEqual(rss.feed.results[0].artistName, "Moneybagg Yo")
            XCTAssertEqual(rss.feed.results[0].artistUrl.absoluteString, "https://itunes.apple.com/us/artist/moneybagg-yo/id991187319")
            XCTAssertEqual(rss.feed.results[0].artworkUrl100.absoluteString, "http://is1.mzstatic.com/image/thumb/Music118/v4/28/25/c8/2825c846-e976-bd16-2fbf-f5bdf3334877/source/200x200bb.png")
            XCTAssertEqual(rss.feed.results[0].copyright, "℗ 2017 N-Less Entertainment, LLC distributed by Interscope Records")
            XCTAssertEqual(rss.feed.results[0].genres.count, 2)
            XCTAssertEqual(rss.feed.results[0].genres[0].genreId, "18")
            XCTAssertEqual(rss.feed.results[0].genres[0].name, "Hip-Hop/Rap")
            XCTAssertEqual(rss.feed.results[0].genres[0].url.absoluteString, "https://itunes.apple.com/us/genre/id18")
            XCTAssertEqual(rss.feed.results[0].genres[1].genreId, "34")
            XCTAssertEqual(rss.feed.results[0].genres[1].name, "Music")
            XCTAssertEqual(rss.feed.results[0].genres[1].url.absoluteString, "https://itunes.apple.com/us/genre/id34")
            XCTAssertEqual(rss.feed.results[0].id, "1267471554")
            XCTAssertEqual(rss.feed.results[0].kind, "album")
            XCTAssertEqual(rss.feed.results[0].name, "Federal 3X")
            XCTAssertEqual(rss.feed.results[0].releaseDate, "2017-08-11")
            XCTAssertEqual(rss.feed.results[0].url.absoluteString, "https://itunes.apple.com/us/album/federal-3x/id1267471554")
            XCTAssertEqual(rss.feed.results[1].artistId, "334854763")
            XCTAssertEqual(rss.feed.results[1].artistName, "Kesha")
            XCTAssertEqual(rss.feed.results[1].artistUrl.absoluteString, "https://itunes.apple.com/us/artist/kesha/id334854763")
            XCTAssertEqual(rss.feed.results[1].artworkUrl100.absoluteString, "http://is1.mzstatic.com/image/thumb/Music117/v4/06/19/3e/06193ee9-3caa-642c-901c-d0097470c50b/source/200x200bb.png")
            XCTAssertEqual(rss.feed.results[1].copyright, "℗ 2017 Kemosabe Records")
            XCTAssertEqual(rss.feed.results[1].genres.count, 2)
            XCTAssertEqual(rss.feed.results[1].genres[0].genreId, "14")
            XCTAssertEqual(rss.feed.results[1].genres[0].name, "Pop")
            XCTAssertEqual(rss.feed.results[1].genres[0].url.absoluteString, "https://itunes.apple.com/us/genre/id14")
            XCTAssertEqual(rss.feed.results[1].genres[1].genreId, "34")
            XCTAssertEqual(rss.feed.results[1].genres[1].name, "Music")
            XCTAssertEqual(rss.feed.results[1].genres[1].url.absoluteString, "https://itunes.apple.com/us/genre/id34")
            XCTAssertEqual(rss.feed.results[1].id, "1253656856")
            XCTAssertEqual(rss.feed.results[1].kind, "album")
            XCTAssertEqual(rss.feed.results[1].name, "Rainbow")
            XCTAssertEqual(rss.feed.results[1].releaseDate, "2017-08-11")
            XCTAssertEqual(rss.feed.results[1].url.absoluteString, "https://itunes.apple.com/us/album/rainbow/id1253656856")
        } catch {
            XCTFail()
        }
    }
}
