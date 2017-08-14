//
//  RssViewController.swift
//  RssReader
//
//  Created by Iwaki Satoshi on 2017/07/26.
//  Copyright © 2017年 Satoshi Iwaki. All rights reserved.
//

import UIKit

class RssViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, RssReaderDelegate {

    @IBOutlet weak var tableView: UITableView!
    var url: URL?
    
    private let reader: RssReader = RssReader()
    private var rss: Rss?
    
    deinit {
        reader.invalidateAndCancel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        reader.delegate = self
        
        guard let url = url else {
            return
        }
        reader.load(url: url)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITableViewDataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rss = rss else {
            return 1
        }
        return rss.feed.results.count;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
        
        guard let rss = rss else {
            cell.textLabel?.text = "Loading..."
            cell.detailTextLabel?.text = ""
            cell.accessoryType = .none
            return cell
        }
        guard indexPath.row < rss.feed.results.count else {
            return cell
        }
        let result = rss.feed.results[indexPath.row];
        cell.textLabel?.text = result.name
        cell.detailTextLabel?.text = result.artistName
        if let image = ImageCache.sharedInstance.cachedImage(url: result.artworkUrl100) {
            cell.imageView?.image = image
        } else {
            cell.imageView?.image = UIImage(named: "NoImage.png")
            ImageCache.sharedInstance.getImage(url: result.artworkUrl100) { (image) in
                tableView.reloadData()
            }
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    //MARK: UITableViewDelegate
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let rss = rss else {
            return
        }
        guard indexPath.row < rss.feed.results.count else {
            return
        }
        
        let result = rss.feed.results[indexPath.row]
        if UIApplication.shared.canOpenURL(result.url) {
            UIApplication.shared.open(result.url, options: [:], completionHandler: nil)
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //MARK: RssReaderDelegate
    func didFinishLoading(rssReader: RssReader, rss: Rss?, error: Error?) -> Void {
        guard let rss = rss else {
            self.showAlert(error: error)
            return
        }
        self.rss = rss
        DispatchQueue.main.sync {
            if let rss = self.rss {
                self.title = rss.feed.title
            }
            tableView.reloadData()
        }
    }
    
    // MARK: - Private methods
    func showAlert(error: Error?) {
        DispatchQueue.main.sync {
            let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: {
                (action: UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}


