application = require("application")

class KeyView extends Backbone.View

  events:
    "click .key-item": "route"

  initialize: ->

  route: (e) ->
    el = e.currentTarget
    if el.classList.toggle "active-sort"
      application.router.navigate "category/#{el.textContent}", true
    else
      application.router.navigate "", true

module.exports = KeyView