application = require("application")

PeriodicTableView = require("views/periodic-table")

table = null

class AppRouter extends Backbone.Router
  initialize: ->
    console.log "Initialized Router"
    table = new PeriodicTableView({
      el: "body"
    })

  routes:
    "":                   "home"
    "element/:element":   "element"
    "category/:element":  "category"
    "state/:state":       "state"

  home: ->
    table.defocus()

  element: (element) ->
    table.focus "atom", element

  category: (category) ->
    table.focus "category", category

  state: (state) ->
    table.focus "state", state

module.exports = AppRouter