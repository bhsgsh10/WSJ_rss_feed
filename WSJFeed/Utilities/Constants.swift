//
//  Constants.swift
//  WSJFeed
//
//  Created by Bhaskar Ghosh on 11/9/20.
//  Copyright © 2020 Bhaskar Ghosh. All rights reserved.
//

import Foundation

enum NetworkResponseError: Error {
    case responseNotReceived
}

enum FeedKeys {
    static let title = "title"
    static let description = "description"
    static let link = "link"
    static let pubDate = "pubDate"
    static let category = "category"
    static let item = "item"
}

enum FeedTitle {
    static let feedTitle = "description"
}

enum FeedType: String {
    case worldNews = "https://feeds.a.dj.com/rss/RSSWorldNews.xml"
    case opinion = "https://feeds.a.dj.com/rss/RSSOpinion.xml"
    case usBusiness = "https://feeds.a.dj.com/rss/WSJcomUSBusiness.xml"
    case marketsNews = "https://feeds.a.dj.com/rss/RSSMarketsMain.xml"
    case tech = "https://feeds.a.dj.com/rss/RSSWSJD.xml"
    case lifestyle = "https://feeds.a.dj.com/rss/RSSLifestyle.xml"
}

enum IBFiles: String {
    case feedTableCell = "FeedTableViewCell"
    case feedWebViewController = "FeedWebViewController"
}

enum DateFormats: String {
    case rssFeedDateFormat = "E, d MMM y HH:mm:ss XXXXX"
    case viewDateFormat = "E d, MMM y h:mm a"
}
