app = require("app")

PeriodicTableView = require("views/periodic-table")

table = null

class AppRouter extends Backbone.Router
  initialize: ->
    console.log "Initialized Router"

    table = new PeriodicTableView({
      el: "body"
    })

  ready: ->
    table.ready()

  routes:
    "":                       "home"

    # searching
    "element/:element":       "element"
    "category/:element":      "category"
    "occurance/:occurance":   "occurance"
    "phase/:phase":           "phase"

    # pages
    "about":                  "about"

  home: ->
    table.defocus()

    document.title = "Atoms | An interactive periodic table of elements"

  element: (element) ->
    table.focus "Name", element
    document.title = "Atoms | #{element}"

  category: (category) ->
    table.focus "Category", category
    document.title = "Atoms | #{category}"

  phase: (phase) ->
    table.focus "Phase", phase
    document.title = "Atoms | #{phase}"

  occurance: (occurance) ->
    table.focus "Occurance", occurance
    document.title = "Atoms | #{occurance}"


  about: ->
    table.focus "About"
    document.title = "Atoms | About"

module.exports = AppRouter
