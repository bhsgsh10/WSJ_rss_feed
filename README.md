# WSJ RSS Feed

This app parses and displays Wall Street Journal's RSS Feed for the following topics:
- Opinion
- World News
- US Business
- Markets
- Technology
- Lifestyle

## Architecture and flow
The app follows the MVVM architecture. The initial view controller initializes a view model that takes care of fetching the feed, and parsing the XML data. When parsing is complete, the view model hands the control back to the view controller, which updates the UI to display the feed.

### Classes and structs
- `Feed`: A model struct containing the name of the feed and an array of `FeedItem`s.
- `FeedItem`: The model representing a single item in the feed. Contains description, link, published date and category.
- `ViewController`: The initial `UIViewController`, that instantiates the view model and updates the UI. It holds an `UITableView` instance, which is used to show the feed.
- `FeedViewModel`: The view model used to fetch feeds and parse them. It uses `NetworkUtility` for making requests and `FeedParser` to parse the responses.
- `NetworkUtility`: Used as a singleton, it basically accepts and fetches the feed for the given endpoint.
- `FeedParser`: Accepts a `Data` object and parses it. Returns a `Feed` object.
- `FeedWebViewController`: Used to show a news item on a web view.
- `Constants`: Contains constants used throughout the app.
