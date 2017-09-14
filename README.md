Expedia API Gem
===

![Build status](https://travis-ci.org/ShoreSuite/expedia-api.svg?branch=develop)

A relatively 'thin' (for now) client for the Expedia Quick Connect (EQC) API: [https://expediaconnectivity.com/developer](https://expediaconnectivity.com/developer)

Uses [`representable`](http://trailblazer.to/gems/representable/) for JSON mapping and [`vcr`](https://github.com/vcr/vcr) to record/replay API interactions

### Usage

```
gem install expedia-api
```

### Release History

##### v0.1
* Initial release
* Initial support for *Product API* at [https://expediaconnectivity.com/apis/product-management/product-api/reference.html](https://expediaconnectivity.com/apis/product-management/product-api/reference.html)
* Supports fetching `Property`, `RoomType`, `RateThreshold`, and `RatePlan` resources

### Contributing to expedia-api

-   Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
-   Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
-   Fork the project.
-   Start a feature/bugfix branch.
-   Commit and push until you are happy with your contribution.
-   Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
-   Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

### Copyright

Copyright (c) 2017 Alistair A. Israel. See
LICENSE.txt for further details.
