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

// Represents the different tags to be parsed in the XML response
enum FeedTags {
    static let title = "title"
    static let description = "description"
    static let link = "link"
    static let pubDate = "pubDate"
    static let category = "category"
    static let item = "item"
}

enum FeedEndpoints: String, CaseIterable {
    case worldNews = "https://feeds.a.dj.com/rss/RSSWorldNews.xml"
    case opinion = "https://feeds.a.dj.com/rss/RSSOpinion.xml"
    case usBusiness = "https://feeds.a.dj.com/rss/WSJcomUSBusiness.xml"
    case marketsNews = "https://feeds.a.dj.com/rss/RSSMarketsMain.xml"
    case tech = "https://feeds.a.dj.com/rss/RSSWSJD.xml"
    case lifestyle = "https://feeds.a.dj.com/rss/RSSLifestyle.xml"
}

// order of feeds to be shown
enum FeedTitleOrder: Int {
    case opinion = 0
    case worldNews = 1
    case usBusiness = 2
    case marketsNew = 3
    case tech = 4
    case lifestyle = 5
}

enum IBFiles: String {
    case storyboardName = "Main"
    case feedTableCell = "FeedTableViewCell"
    case feedWebViewController = "FeedWebViewController"
}

enum DateFormats: String {
    case rssFeedDateFormat = "E, d MMM y HH:mm:ss XXXXX"
    case viewDateFormat = "E d, MMM y h:mm a"
}

// Feed titles received in API response
enum RSSFeedTitles: String {
    case rssOpinion = "RSSOpinion"
    case worldNews = "World News"
    case usBusiness = "US Business"
    case markets = "Markets"
    case tech = "WSJD - Technology"
    case lifestyle = "Lifestyle"
}

// Feed titles we want to show on the app
enum ViewableFeedTitles: String {
    case opinion = "Opinion"
    case worldNews = "World News"
    case usBusiness = "US Business"
    case markets = "Markets News"
    case tech = "Technology: What's News"
    case lifestyle = "Lifestyle"
}
