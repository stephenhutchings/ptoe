application = require("application")
template = require("./templates/elements")

ElementView = require("./element")
InfoView = require("./info")
KeyView = require("./key")

class PeriodicTableView extends Backbone.View
  elements: []
  attempts: 0

  template: template

  events:
    "start":         "savePosition"
    "move":          "savePosition"

    "swipeleft":     "next"
    "swiperight":    "previous"

  initialize: ->
    @render()
    console.log Backbone.history.fragment
    if Backbone.history.fragment is "" and !@el.classList.contains "sorted"
      app.router.navigate Backbone.history.fragment, true

  render: ->
    @$el.html @template(application.elementCollection)

    @infoView = new InfoView el: "#info"
    @keyView = new KeyView el: "#keys"

    # setTimeout( =>

    for el, i in @el.querySelectorAll(".el-container")
      @elements.push new ElementView
        el: el
        model: application.elementCollection.findWhere "Number": +el.dataset.number

    # , 100)


  savePosition: (e) ->
    point = if e.data.touches then e.data.touches[0] else e.data
    @pos = [
      point.clientX,
      point.clientY
    ]

  focus: (key, value) ->
    multiple = 0
    @el.classList.add "sorted"
    clearTimeout @timeout if @timeout

    @pos = null unless key is "Name"

    application.elementCollection
      .each (model) =>
        if model.get(key) is value
          model.trigger "focus"
          model.trigger "show", multiple
          multiple++
        else
          model.trigger "hide", @pos

    console.log value
    child = application.infoCollection.findWhere title: value
    if child
      html = child.get("html")
      @attempts = 0
    else
      html = "Could not load the information."
      @timeout = setTimeout( =>
        if @attempts < 10
          @focus key, value
          @attempts++
      , 1000 * @attempts)
    
    @infoView.render(html)

  defocus: ->
    @el.classList.remove "sorted"
    clearTimeout @timeout if @timeout

    for el in @el.querySelectorAll ".active-sort"
      el.classList.remove "active-sort"

    application.elementCollection
      .each (model) =>
        model.trigger "show"

    @infoView.hide()

    next: ->

    previous: ->


module.exports = PeriodicTableView