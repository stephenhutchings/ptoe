Crawler = require 'simplecrawler'

###
###


crawler = Crawler.crawl "http://wikipedia.org/wiki/"

conditionID = myCrawler.addFetchCondition (parsedURL) ->
  parsedURL.path.match(/\.html$/i)

crawler.interval = 2500

crawler.on "fetchcomplete", (queueItem) ->
  console.log "Completed fetching resource:" queueItem.url