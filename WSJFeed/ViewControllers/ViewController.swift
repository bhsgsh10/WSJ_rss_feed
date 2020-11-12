//
//  ViewController.swift
//  WSJFeed
//
//  Created by Bhaskar Ghosh on 11/9/20.
//  Copyright © 2020 Bhaskar Ghosh. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet weak var rssTableView: UITableView!
    
    var rssFeed: Feed?
    var xmlParser: FeedParser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        fetchFeed()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    private func setupTableView() {
        rssTableView.delegate = self
        rssTableView.dataSource = self
        
        let nib = UINib(nibName: "FeedTableViewCell", bundle: nil)
        rssTableView.register(nib, forCellReuseIdentifier: "feedCell")
        
        rssTableView.estimatedRowHeight = 400
        rssTableView.rowHeight = UITableView.automaticDimension
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func fetchFeed() {
        NetworkUtility.shared.fetchRSSFeed(for: FeedType.worldNews.rawValue) {[weak self] data, error in
            
            guard let data = data, error == nil else {
                print(error!)
                //show an alert from here
                return
            }
            
            let parser = FeedParser()
            if let feed: Feed = parser.parseFeed(with: data) {
                //reload table here
                self?.rssFeed = feed
                DispatchQueue.main.async {
                    self?.title = feed.feedName
                    self?.rssTableView.reloadData()
                }
            }
        }
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rssFeed?.feedItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "feedCell",
                                                 for: indexPath) as! FeedTableViewCell
        
        if let feedItem = rssFeed?.feedItems?[indexPath.row] {
            cell = configureFeedCell(cell: cell, feedItem: feedItem)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        if let link = rssFeed?.feedItems?[row].link {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let webviewVC = storyboard.instantiateViewController(withIdentifier: "FeedWebViewController") as! FeedWebViewController
            webviewVC.webUrl = URL(string: link)
            navigationController?.pushViewController(webviewVC, animated: true)
        }
    }
    
    private func configureFeedCell(cell: FeedTableViewCell, feedItem: FeedItem) -> FeedTableViewCell {
           
       cell.headlineLabel.text = feedItem.title
       cell.descriptionLabel.text = feedItem.description
        
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = DateFormats.viewDateFormat.rawValue
       let date = dateFormatter.string(from: feedItem.publishedDate!)
       cell.dateLabel.text = date
       
       cell.categoryLabel.text = feedItem.category?.uppercased()
       
       return cell
       }
}
