//
//  BookmarkViewController.swift
//  RssReader
//
//  Created by Iwaki Satoshi on 2017/08/06.
//  Copyright © 2017年 Satoshi Iwaki. All rights reserved.
//

import UIKit
 
class BookmarkViewController: UITableViewController, AddBookmarkViewControllerDelegate {
    private var bookmarks: [Bookmark] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        let addButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(BookmarkViewController.tappedAddButtonItem(sender:)))
        self.navigationItem.rightBarButtonItem = addButtonItem
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.title = "RSS Bookmarks"
        
        restoreBookmarks()
        if self.bookmarks.count == 0 {
            self.bookmarks.append(Bookmark(title: "Apple Music - New Release Top 100",
                                         url: URL(string: "https://rss.itunes.apple.com/api/v1/us/apple-music/new-releases/all/100/explicit.json")!))
            self.bookmarks.append(Bookmark(title: "Apple Music - Top Albums 100",
                                         url: URL(string: "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/100/explicit.json")!))
            self.bookmarks.append(Bookmark(title: "iOS App - New Apps We Love Top 100",
                                         url: URL(string: "https://rss.itunes.apple.com/api/v1/us/ios-apps/new-apps-we-love/all/100/explicit.json")!))
        }
        storeBookmarks()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)

        // Configure the cell...
        guard indexPath.row < bookmarks.count else {
            cell.textLabel?.text = "No item"
            cell.accessoryType = .none
            return cell
        }
        let bookmark = bookmarks[indexPath.row]
        
        cell.textLabel?.text = bookmark.title
        cell.accessoryType = .disclosureIndicator

        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            bookmarks.remove(at: indexPath.row)
            storeBookmarks()
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
        return true
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < bookmarks.count else {
            return
        }
        self.performSegue(withIdentifier: "showRssViewController", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showRssViewController" {
            guard let indexPath = self.tableView.indexPathForSelectedRow else {
                return;
            }
            let bookmark = self.bookmarks[indexPath.row]
            let viewController = segue.destination as! RssViewController
            viewController.url = bookmark.url
        } else if segue.identifier == "showAddBookmarkViewController" {
            let naviController = segue.destination as! UINavigationController
            let viewController = naviController.topViewController as! AddBookmarkViewController
            viewController.delegate = self
        }
    }

    // MARK: - AddBookmarkViewControllerDelegate
    
    func didEditBookmark(_ sender: AddBookmarkViewController, bookmark: Bookmark) {
        self.bookmarks.append(bookmark)
        self.storeBookmarks()
        self.tableView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    func didCancel(_ sender: AddBookmarkViewController) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func tappedAddButtonItem(sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "showAddBookmarkViewController", sender: self)
    }
    
    // MARK: - Private methods

    func storeBookmarks() {
        guard let data = try? JSONEncoder().encode(self.bookmarks) else {
            return
        }
        UserDefaults.standard.set(data, forKey: "Bookmarks")
        UserDefaults.standard.synchronize()
    }
    
    func restoreBookmarks() {
        guard let data = UserDefaults.standard.object(forKey: "Bookmarks") as? Data else {
            return
        }
        guard let bookmarks = try? JSONDecoder().decode([Bookmark].self, from: data) else {
            return
        }
        self.bookmarks = bookmarks
    }
}
