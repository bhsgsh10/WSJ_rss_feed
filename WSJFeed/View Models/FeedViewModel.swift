//
//  FeedViewModel.swift
//  WSJFeed
//
//  Created by Bhaskar Ghosh on 11/11/20.
//  Copyright © 2020 Bhaskar Ghosh. All rights reserved.
//

import Foundation

class FeedViewModel {
    
    //MARK: - Properties
    var rssFeed: [Int: Feed]?
    private var xmlParser: FeedParser?
    private var dispatchGroup: DispatchGroup?
    
    init() {
        rssFeed = [:]
        dispatchGroup = DispatchGroup()
    }
    
    /// Iterates over all the endpoints for different feeds, fetches the news items and parses them into the rssFeed dictionary.
    ///
    /// The method uses a DispatchGroup to make sure all the endpoints are queried and finally notifies the caller using a completion block.
    func getFeedData(completion: @escaping () -> Void) {
        FeedEndpoints.allCases.forEach { endpoint in
            dispatchGroup?.enter()
            NetworkUtility.shared.fetchRSSFeed(for: endpoint.rawValue) {[weak self] data, error in
                guard let data = data, error == nil else {
                    self?.dispatchGroup?.leave()
                    return
                }
                self?.xmlParser = FeedParser()
                if let feedData = self?.xmlParser?.parseFeed(with: data) {
                    let key = self?.getKey(for: feedData.feedName ?? "") ?? 0
                    self?.rssFeed?[key] = feedData
                }
                self?.dispatchGroup?.leave()
            }
        }
        
        dispatchGroup?.notify(queue: DispatchQueue.main,
                              execute: {
                                completion()
        })
    }
    
    /// Returns key for given feed title. The keys are used to ensure order of the feeds on the view
    ///
    /// Takes the title and runs it through a switch-case to get the required key values.
    private func getKey(for title: String) -> Int {
        var key = -1
        switch title {
        case ViewableFeedTitles.opinion.rawValue:
           key = 0
            break
        case ViewableFeedTitles.worldNews.rawValue:
            key = 1
            break
        case ViewableFeedTitles.usBusiness.rawValue:
            key = 2
            break
        case ViewableFeedTitles.markets.rawValue:
            key = 3
            break
        case ViewableFeedTitles.tech.rawValue:
            key = 4
            break
        case ViewableFeedTitles.lifestyle.rawValue:
            key = 5
            break
        default:
            break
        }
        return key
    }
}
