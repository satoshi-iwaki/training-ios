//
//  ViewController.swift
//  RssReader
//
//  Created by Iwaki Satoshi on 2017/07/26.
//  Copyright © 2017年 Satoshi Iwaki. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, RssReaderDelegate {

    @IBOutlet weak var tableView: UITableView!
    private let reader: RssReader = RssReader()
    private var feed: RssFeed?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        reader.delegate = self
        let url = URL(string: "https://rss.itunes.apple.com/api/v1/us/apple-music/new-music/10/explicit/json")!
        reader.load(url: url)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: UITableViewDataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let feed = feed else {
            return 0
        }
        return feed.results.count;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
//        cell.imageView!.image
        
        guard let feed = feed else {
            return cell
        }
        guard indexPath.row < feed.results.count else {
            return cell
        }
        let result = feed.results[indexPath.row];
        cell.textLabel?.text = result.name
        cell.detailTextLabel?.text = result.artistName
        
        do {
            let data = try Data(contentsOf: result.artworkUrl100, options: [])
            cell.imageView?.image = UIImage(data: data)
        } catch {
            
        }
        return cell
    }

    //MARK: UITableViewDelegate
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let feed = feed else {
            return
        }
        guard feed.results.count < indexPath.row else {
            return
        }
    }
    
    //MARK: RssReaderDelegate
    func didFinishLoading(rssReader: RssReader, rssFeed: RssFeed?, error: Error?) -> Void {
        feed = rssFeed
        DispatchQueue.main.sync {
            tableView.reloadData()
        }
    }
}


