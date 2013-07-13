# Example use of simplecrawler, courtesy of @breck7! Thanks mate. :)
fs = require("node-fs")
url = require("url")
wrench = require("wrench")
Crawler = require("simplecrawler").Crawler

###
@param String. Domain to download.
@Param Function. Callback when crawl is complete.
###
downloadSite = (domain, callback) ->
  
  # Where to save downloaded data
  outputDirectory = __dirname + "/" + domain
  myCrawler = new Crawler(domain)
  myCrawler.interval = 250
  myCrawler.maxConcurrency = 5
  myCrawler.on "fetchcomplete", (queueItem, responseBuffer, response) ->
    
    # Parse url
    parsed = url.parse(queueItem.url)
    
    # Rename / to index.html
    parsed.pathname = "/index.html"  if parsed.pathname is "/"
    
    # Get directory name in order to create any nested dirs
    dirname = outputDirectory + parsed.pathname.replace(/\/[^\/]+$/, "")
    
    # Path to save file
    filepath = outputDirectory + parsed.pathname
    
    # Check if DIR exists
    fs.exists dirname, (exists) ->
      
      # If DIR exists, write file
      if exists
        fs.writeFile filepath, responseBuffer, ->

      
      # Else, recursively create dir using node-fs, then write file
      else
        fs.mkdir dirname, 0755, true, (err) ->
          fs.writeFile filepath, responseBuffer, ->



    console.log "I just received %s (%d bytes)", queueItem.url, responseBuffer.length
    console.log "It was a resource of type %s", response.headers["content-type"]

  
  # Fire callback
  myCrawler.on "complete", ->
    callback()

  
  # Start Crawl
  myCrawler.start()

if process.argv.length < 3
  console.log "Usage: node downloadSiteExample.js mysite.com"
  process.exit 1
downloadSite process.argv[2], ->
  console.log "Done!"
