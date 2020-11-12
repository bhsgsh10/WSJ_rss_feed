//
//  ViewController.swift
//  WSJFeed
//
//  Created by Bhaskar Ghosh on 11/9/20.
//  Copyright © 2020 Bhaskar Ghosh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var rssTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Properties
    var feedViewModel: FeedViewModel?
    
    //MARK: - Local constants
    enum LocalConstants {
        static let tableCellReuseIdentifier = "feedCell"
        static let estimatedTableRowHeight: CGFloat = 400.0
        static let headerViewBackgroundColor = UIColor(red: 238/255,
                                                green: 238/255,
                                                blue: 238/255,
                                                alpha: 1.0)
        static let headerLabelFont = UIFont(name: "Helvetica", size: 20)
        static let headerViewHeight: CGFloat = 60.0
        static let labelHeight: CGFloat = 28.0
        static let margin: CGFloat = 16.0
        static let alertTitle: String = "No Data Found"
        static let alertMessage: String = "No feed was found. Please try again later"
        static let close: String = "Close"
    }
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupActivityIndicator()
        configureNavigationBar(largeTitles: false)
        
        initiateFeedViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureNavigationBar(largeTitles: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        configureNavigationBar(largeTitles: false)
    }
}

//MARK: - Private functions
extension ViewController {
    /// Sets up delegate and data source for the rssTableView, registers cells and sets row heights
    private func setupTableView() {
        rssTableView.delegate = self
        rssTableView.dataSource = self
        
        let nib = UINib(nibName: IBFiles.feedTableCell.rawValue, bundle: nil)
        rssTableView.register(nib, forCellReuseIdentifier: LocalConstants.tableCellReuseIdentifier)
    }
    
    ///Sets up the activity indicator and starts animating
    private func setupActivityIndicator() {
        view.bringSubviewToFront(activityIndicator)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    /// Configures the navigation bar
    private func configureNavigationBar(largeTitles: Bool) {
        self.title = "News Feed"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    /// Instantiates the view model and asks it to fetch data. Waits for completion and updates UI
    private func initiateFeedViewModel() {
        feedViewModel = FeedViewModel()
        feedViewModel?.getFeedData {[weak self] in
            self?.updateUI()
        }
    }
    
    /// Stops activity indicator and reloads table
    private func updateUI() {
        
        DispatchQueue.main.async {[weak self] in
            
            self?.activityIndicator.isHidden = true
            self?.activityIndicator.stopAnimating()
            self?.rssTableView.reloadData()
            
            guard let _ = self?.feedViewModel?.rssFeed else {
                self?.showNoDataAlert()
                return
            }
        }
    }
    
    /// Shows alert when no data is received
    private func showNoDataAlert() {
        let alertController = UIAlertController(title: LocalConstants.alertTitle,
                                                message: LocalConstants.alertMessage,
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: LocalConstants.close,
                                   style: .cancel,
                                   handler: nil)
        alertController.addAction(action)
        navigationController?.present(alertController,
                                        animated: true,
                                        completion: nil)
    }
    
    /// Configures the text values for different labels in FeedTableViewCell
    private func configureFeedCell(cell: FeedTableViewCell,
                                   feedItem: FeedItem) -> FeedTableViewCell {
           
       cell.headlineLabel.text = feedItem.title
       cell.descriptionLabel.text = feedItem.description
       cell.dateLabel.text = feedItem.publishedDateStr
       cell.categoryLabel.text = feedItem.category?.uppercased()
       
       return cell
    }
}

//MARK: - UITableView Data source and delegate methods
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: -- Number of values
    func numberOfSections(in tableView: UITableView) -> Int {
        return feedViewModel?.rssFeed?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return feedViewModel?.rssFeed?[section]?.feedItems?.count ?? 0
    }
    
    //MARK: -- Estimating heights
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return LocalConstants.headerViewHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return LocalConstants.estimatedTableRowHeight
    }
    
    //MARK: -- Headers and cells
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0,
                                              width: view.bounds.width, height: LocalConstants.headerViewHeight))
        let label = UILabel(frame: CGRect(x: LocalConstants.margin, y: LocalConstants.margin,
                                          width: view.bounds.width - LocalConstants.margin, height: LocalConstants.labelHeight))
        
        label.font = LocalConstants.headerLabelFont
        headerView.addSubview(label)
        headerView.backgroundColor = LocalConstants.headerViewBackgroundColor
        label.text = feedViewModel?.rssFeed?[section]?.feedName ?? ""
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: LocalConstants.tableCellReuseIdentifier,
                                                 for: indexPath) as! FeedTableViewCell
        
        if let feedItem = feedViewModel?.rssFeed?[indexPath.section]?.feedItems?[indexPath.row] {
            cell = configureFeedCell(cell: cell, feedItem: feedItem)
        }

        return cell
    }
    
    //MARK: -- Handle cell click
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        let urlLink = feedViewModel?.rssFeed?[indexPath.section]?.feedItems?[indexPath.row].link
        if let link = urlLink  {
            let storyboard = UIStoryboard(name: IBFiles.storyboardName.rawValue, bundle: nil)
            
            let webviewVC = storyboard.instantiateViewController(withIdentifier: IBFiles.feedWebViewController.rawValue) as! FeedWebViewController
            webviewVC.webUrl = URL(string: link)
            let navController = UINavigationController(rootViewController: webviewVC)
            DispatchQueue.main.async {[weak self] in
                self?.navigationController?.present(navController,
                                                    animated: true,
                                                    completion: nil)  
            }
        }
    }
}
