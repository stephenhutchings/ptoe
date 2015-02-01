iOSTap = require("lib/iostap")

Application =
  initialize: (callback) ->
    Router = require("lib/router")
    ElementCollection = require("collections/elements")
    InfoCollection = require("collections/info")

    iOSTap.initialize()

    require "lib/element.toggle"

    @router = new Router()
    window.app = @

    @elementCollection = new ElementCollection()
    @elementCollection.fetch
      success: =>
        console.log "Fetched element data"
        @router.ready()

        @infoCollection = new InfoCollection()
        @infoCollection.fetch
          success: =>
            console.log "Fetched information"

            # Crawler = require "lib/crawl"
            # @crawler = new Crawler()
            # @crawler.initialize(@infoCollection, "other")

        callback()

module.exports = Application
