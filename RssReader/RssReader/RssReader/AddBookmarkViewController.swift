//
//  AddBookmarkViewController.swift
//  RssReader
//
//  Created by Iwaki Satoshi on 2017/08/11.
//  Copyright © 2017年 Satoshi Iwaki. All rights reserved.
//

import UIKit

protocol AddBookmarkViewControllerDelegate {
    func didEditBookmark(_ sender: AddBookmarkViewController, bookmark: Bookmark);
    func didCancel(_ sender: AddBookmarkViewController);
}

class AddBookmarkViewController: UITableViewController {
    var delegate: AddBookmarkViewControllerDelegate?
    private var selectedIndexPath: IndexPath?
    
    struct AppleFeed {
        let title: String
        let path: String
        var count: Int
    }
    
    private let appleFeeds: [AppleFeed] = [
        AppleFeed(title: "Apple Music - Top Albums",
                  path: "apple-music/new-music",
                  count:100),
        AppleFeed(title: "iTunes Music - Top Albums",
                  path: "itunes-music/top-albums",
                  count:10),
        AppleFeed(title: "iOS Apps - New Apps We Love",
                  path: "ios-apps/new-apps-we-love",
                  count:10),
        AppleFeed(title: "macOS Apps - Top Mac Apps",
                  path: "macos-apps/top-mac-apps",
                  count:10)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.title = "Add Bookmark"
        let cancelButtonItem = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(AddBookmarkViewController.tappedCancelButtonItem(sender:)))
        self.navigationItem.rightBarButtonItem = cancelButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appleFeeds.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)

        // Configure the cell...
        guard indexPath.row < appleFeeds.count else {
            cell.textLabel?.text = ""
            cell.accessoryType = .none
            return cell
        }
        
        let appleFeed = appleFeeds[indexPath.row]
        cell.textLabel?.text = appleFeed.title
        
        if indexPath == self.selectedIndexPath {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < appleFeeds.count else {
            return
        }
        self.selectedIndexPath = indexPath;
        tableView.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func tappedSaveButton(sender: UIButton) {
        guard let delegate = self.delegate else {
            return
        }
        
        guard let indexPath = self.selectedIndexPath else {
            return
        }
        if let country = Locale.current.regionCode {
            let appleFeed = appleFeeds[indexPath.row]
            var urlComponents = URLComponents(string: "https://rss.itunes.apple.com/")!
            urlComponents.path = String(format: "/api/v1/%@/%@/%d/explicit.json", country.lowercased(), appleFeed.path, appleFeed.count)
            let bookmark = Bookmark(title: String(format: "%@ %d", appleFeed.title, appleFeed.count),
                                    url: urlComponents.url!)
            delegate.didEditBookmark(self, bookmark: bookmark)
        }
    }
    @objc func tappedCancelButtonItem(sender: UIBarButtonItem) {
        guard let delegate = self.delegate else {
            return
        }
        delegate.didCancel(self)
    }
}
