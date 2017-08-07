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
        let json = """
        {
            "feed":{
                "title":"New Releases",
                "id":"https://rss.itunes.apple.com/api/v1/us/apple-music/new-music/10/explicit/json",
                "author":{
                    "name":"iTunes Store",
                    "uri":"http://wwww.apple.com/us/itunes/"
                },
                "links":[
                    {"self":"https://rss.itunes.apple.com/api/v1/us/apple-music/new-music/10/explicit/json"},
                    {"alternate":"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewRoom?fcId=976405703"}
                ],
                "copyright":"Copyright © 2017 Apple Inc. All Rights Reserved.",
                "country":"us",
                "icon":"http://itunes.apple.com/favicon.ico",
                "updated":"2017-07-30T01:52:18.000-07:00",
                "results":[
                    {
                        "artistId":"23203991",
                        "artistName":"Arcade Fire",
                        "artistUrl":"https://itunes.apple.com/us/artist/arcade-fire/id23203991",
                        "artworkUrl100":"http://is1.mzstatic.com/image/thumb/Music127/v4/9d/1f/88/9d1f88d7-0734-68b2-8bac-9f094b8b8967/source/200x200bb.png",
                        "contentAdvisoryRating":"",
                        "copyright":"℗ 2017 Arcade Fire Music under exclusive licence to Sony Music Entertainment  UK Limited",
                        "genreNames":[
                            "Alternative","Music"
                        ],
                        "id":"1240796998",
                        "kind":"album",
                        "name":"Everything Now",
                        "primaryGenreName":"Alternative",
                        "releaseDate":"2017-07-28T00:00:00Z",
                        "trackCensoredName":"Everything Now",
                        "trackExplicitness":"",
                        "url":"https://itunes.apple.com/us/album/everything-now/id1240796998",
                        "version":""
                    },
                    {
                        "artistId":"598667873",
                        "artistName":"Vic Mensa",
                        "artistUrl":"https://itunes.apple.com/us/artist/vic-mensa/id598667873",
                        "artworkUrl100":"http://is4.mzstatic.com/image/thumb/Music117/v4/8c/99/e8/8c99e859-3a96-67c3-f035-43265a77a261/source/200x200bb.png",
                        "contentAdvisoryRating":"Explicit",
                        "copyright":"℗ 2017 Roc Nation Records, LLC",
                        "genreNames":[
                            "Hip-Hop/Rap",
                            "Music"
                        ],
                        "id":"1256952577",
                        "kind":"album",
                        "name":"The Autobiography",
                        "primaryGenreName":"Hip-Hop/Rap",
                        "releaseDate":"2017-07-28T00:00:00Z",
                        "trackCensoredName":"The Autobiography",
                        "trackExplicitness":"Explicit",
                        "url":"https://itunes.apple.com/us/album/the-autobiography/id1256952577",
                        "version":""
                    }         
                ]
            }
        }
        """.data(using: .utf8)!
        
        let url = URL(string: "https://rss.itunes.apple.com/api/v1/us/apple-music/new-music/10/explicit/json")!
        let rssReader = RssReader()
        
        do {
            let json2 = try Data(contentsOf: url, options: [])
            let rssFeed = try rssReader.decode(data: json2)
            
            XCTAssertNotNil(rssFeed)
            
            
        } catch {
            XCTFail()
        }
        
    }
    
    
}
