//
//  RssListViewController.swift
//  RssReader
//
//  Created by Iwaki Satoshi on 2017/08/06.
//  Copyright © 2017年 Satoshi Iwaki. All rights reserved.
//

import UIKit
 
class RssListViewController: UITableViewController {
    var bookmarks: [RssBookmark] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.title = "RSS Bookmarks"
        
        if bookmarks.count == 0 {
            bookmarks.append(RssBookmark(title: "Apple Music - Top Albums 100",
                                         url: URL(string: "https://rss.itunes.apple.com/api/v1/us/apple-music/new-music/100/explicit/json")!))
            bookmarks.append(RssBookmark(title: "iTunes Music - Top Albums 100",
                                         url: URL(string: "https://rss.itunes.apple.com/api/v1/us/itunes-music/top-albums/100/explicit/json")!))
            bookmarks.append(RssBookmark(title: "iOS App - New Apps We Love Top 100",
                                         url: URL(string: "https://rss.itunes.apple.com/api/v1/us/ios-apps/new-apps-we-love/100/explicit/json")!))
        }
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
        return bookmarks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Default", for: indexPath)

        // Configure the cell...
        
        guard indexPath.row < bookmarks.count else {
            return cell
        }
        let bookmark = bookmarks[indexPath.row]
        
        cell.textLabel?.text = bookmark.title
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            bookmarks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        bookmarks.swapAt(fromIndexPath.row, to.row)
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < bookmarks.count else {
            return
        }
        self.performSegue(withIdentifier: "showRssViewController", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRssViewController" {
            guard let indexPath = self.tableView.indexPathForSelectedRow else {
                return;
            }
            let bookmark = self.bookmarks[indexPath.row]
            let rssViewController = segue.destination as! RssViewController
            rssViewController.url = bookmark.url
        }
    }

}
