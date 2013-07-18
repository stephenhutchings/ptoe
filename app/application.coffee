Events = require("lib/touch")

Application =
  initialize: (callback) ->
    Router = require("lib/router")
    ElementCollection = require("collections/elements")
    InfoCollection = require("collections/info")

    @infoCollection = new InfoCollection()
    @infoCollection.fetch
      success: =>

        Crawler = require "crawl"
        @crawler = new Crawler()
        # @crawler.initialize(@infoCollection, "info")
    
    @elementCollection = new ElementCollection()
    @elementCollection.fetch
      success: =>
        console.log "Fetched element data"
        @router = new Router()
        window.app = @
        callback()

module.exports = Application
