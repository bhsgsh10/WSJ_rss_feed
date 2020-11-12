//
//  FeedParser.swift
//  WSJFeed
//
//  Created by Bhaskar Ghosh on 11/10/20.
//  Copyright © 2020 Bhaskar Ghosh. All rights reserved.
//

import Foundation

class FeedParser: NSObject {
    
    private var rssFeed: Feed?
    private var results: [[String: Any]]?
    private var isItemAppending: Bool = false
    private var currentValue: String = ""
    private var currentElement: String = ""
    private var currentDictionary: [String: Any]?
    private var feedTags = Set([FeedTags.title,
                                FeedTags.pubDate,
                                FeedTags.link,
                                FeedTags.description,
                                FeedTags.category])
    
    
    override init() {
        super.init()
    }
    
    func parseFeed(with data: Data) -> Feed? {
        let parser = XMLParser(data: data)
        parser.delegate = self
        if parser.parse() {
            rssFeed?.feedItems = getFeedItemsFromResults()
        }
        
        return rssFeed
    }
    
    func getFeedItemsFromResults() -> [FeedItem]? {
        var feedItems = [FeedItem]()
        if let feedResults = results {
            for result in feedResults {
                var feedItem = FeedItem()
                feedItem.title = result[FeedTags.title] as? String
                feedItem.link = result[FeedTags.link] as? String
                feedItem.category = result[FeedTags.category] as? String
                feedItem.description = result[FeedTags.description] as? String
                
                let modifiedDate = handleDate(dateString: result[FeedTags.pubDate] as? String)
                feedItem.publishedDate = modifiedDate
                
                feedItems.append(feedItem)
            }
        }
        
        feedItems.sort {
            $0.publishedDate! > $1.publishedDate!
        }
        
        return feedItems
    }
    
    func handleDate(dateString: String?) -> Date {
        guard let dateString = dateString else {
            return Date()
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormats.rssFeedDateFormat.rawValue
        if let dateFromStr = dateFormatter.date(from: dateString) {
            return dateFromStr
        }
        
        return Date()
    }
}

extension FeedParser: XMLParserDelegate {
    func parserDidStartDocument(_ parser: XMLParser) {
        results = []
        rssFeed = Feed()
    }
    
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
        
        currentElement = elementName
        if elementName == FeedTags.item {
            isItemAppending = true
            currentDictionary = [:]
        }
        
        if (isItemAppending && feedTags.contains(elementName)) ||
        elementName == FeedTags.description {
            currentValue = ""
        }
    }
    
    func parser(_ parser: XMLParser,
                foundCharacters string: String) {
        
        if isItemAppending || currentElement == FeedTags.description {
            currentValue += string
        }
    }
    
    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
        
        if !isItemAppending && elementName == FeedTags.description {
            rssFeed?.feedName = getViewableFeedTitle(for: currentValue)
        }
        
        
        if elementName == FeedTags.item {
            if let currDict = currentDictionary {
                results?.append(currDict)
            }
            isItemAppending = false
        } else if isItemAppending && feedTags.contains(elementName) {
            currentDictionary![elementName] = currentValue
            currentValue = ""
        }
    }
    
    func parser(_ parser: XMLParser,
                parseErrorOccurred parseError: Error) {
         
        print("Parsing failed due to error \(parseError)")
    }
    
    private func getViewableFeedTitle(for title: String) -> String {
        var modifiedTitle = title
        switch title {
        case RSSFeedTitles.rssOpinion.rawValue:
            modifiedTitle = ViewableFeedTitles.opinion.rawValue
            break
        case RSSFeedTitles.worldNews.rawValue:
            modifiedTitle = ViewableFeedTitles.worldNews.rawValue
            break
        case RSSFeedTitles.usBusiness.rawValue:
            modifiedTitle = ViewableFeedTitles.usBusiness.rawValue
            break
        case RSSFeedTitles.tech.rawValue:
            modifiedTitle = ViewableFeedTitles.tech.rawValue
            break
        case RSSFeedTitles.markets.rawValue:
            modifiedTitle = ViewableFeedTitles.markets.rawValue
            break
        case RSSFeedTitles.lifestyle.rawValue:
            modifiedTitle = ViewableFeedTitles.lifestyle.rawValue
            break
        default:
            break
        }
        return modifiedTitle
    }
}
