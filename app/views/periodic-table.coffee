application = require("application")
template = require("./templates/elements")

ElementView = require("./element")
InfoView = require("./info")
KeyView = require("./key")

class PeriodicTableView extends Backbone.View
  elements: []

  template: template

  events:
    "start":               "savePosition"
    "move":                "savePosition"

    # "end .el":                 "selectElement"
    # "end .material .key-item": "selectCategory"
    # "end .state .key-item":    "selectState"

  initialize: ->
    @render()

  render: ->
    @$el.html @template(application.elementCollection)

    @infoView = new InfoView el: "#info"
    @keyView = new KeyView el: "#keys"

    for el, i in @el.querySelectorAll(".el-container")
      @elements.push new ElementView
        el: el
        model: application.elementCollection.findWhere "Number": +el.dataset.number


  savePosition: (e) ->
    if e.data.touches
      @pos = [e.data.touches[0].clientX, e.data.touches[0].clientY]
    else
      @pos = [e.data.clientX, e.data.clientY]

  focus: (key, value) ->
    multiple = 0
    @el.classList.add "sorted"

    @pos = null unless key is "atom"

    application.elementCollection
      .each (model) =>
        if model.get(key) is value
          model.trigger "focus"
          model.trigger "show", multiple
          multiple++
        else
          model.trigger "hide", @pos


    child = application.infoCollection.findWhere title: value
    console.log value
    if child
      html = child.get("html")
    else
      html = "Could not load the information."
    @infoView.render(html)

  defocus: ->
    @el.classList.remove "sorted"
    for el in @el.querySelectorAll ".active-sort"
      el.classList.remove "sorted"
    application.elementCollection
      .each (model) =>
        model.trigger "show"

    @infoView.hide()


module.exports = PeriodicTableView