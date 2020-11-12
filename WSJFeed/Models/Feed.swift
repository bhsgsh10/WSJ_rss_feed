//
//  Feed.swift
//  WSJFeed
//
//  Created by Bhaskar Ghosh on 11/9/20.
//  Copyright © 2020 Bhaskar Ghosh. All rights reserved.
//

import Foundation

struct Feed {
    var feedName: String?
    var feedItems: [FeedItem]?
}

struct FeedItem {
    var title: String?
    var description: String?
    var publishedDateStr: String?
    var publishedDate: Date? {
        didSet {
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = DateFormats.viewDateFormat.rawValue
            publishedDateStr = dateFormatter.string(from: publishedDate!)
        }
    }
    
    var category: String?
    var link: String?
}
