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
    private var feedKeys = Set([FeedKeys.title,
                                FeedKeys.pubDate,
                                FeedKeys.link,
                                FeedKeys.description,
                                FeedKeys.category])
    
    
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
                feedItem.title = result[FeedKeys.title] as? String
                feedItem.link = result[FeedKeys.link] as? String
                feedItem.category = result[FeedKeys.category] as? String
                feedItem.description = result[FeedKeys.description] as? String
                
                let modifiedDate = handleDate(dateString: result[FeedKeys.pubDate] as? String)
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
        if elementName == FeedKeys.item {
            isItemAppending = true
            currentDictionary = [:]
        }
        
        if (isItemAppending && feedKeys.contains(elementName)) ||
        elementName == FeedKeys.description {
            currentValue = ""
        }
    }
    
    func parser(_ parser: XMLParser,
                foundCharacters string: String) {
        
        if isItemAppending || currentElement == FeedKeys.description {
            currentValue += string
        }
    }
    
    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
        
        if !isItemAppending && elementName == FeedKeys.description {
            rssFeed?.feedName = currentValue
        }
        
        
        if elementName == FeedKeys.item {
            if let currDict = currentDictionary {
                results?.append(currDict)
            }
            isItemAppending = false
        } else if isItemAppending && feedKeys.contains(elementName) {
            currentDictionary![elementName] = currentValue
            currentValue = ""
        }
    }
    
    func parser(_ parser: XMLParser,
                parseErrorOccurred parseError: Error) {
         
        //show an alert here and reload table
    }
}
