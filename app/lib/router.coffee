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
    table.focus "Name", element

  category: (category) ->
    table.focus "Category", category.toLowerCase()

  state: (state) ->
    table.focus "Phase", state

module.exports = AppRouter