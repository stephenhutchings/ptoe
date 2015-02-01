element = require("models/element")

class ElementCollection extends Backbone.Collection
  url: ->
    "data/wikiElements.json"

  model: element

  comparator: (element) ->
    element.get("atomic_number")

  initialize: ->

module.exports = ElementCollection
