app = require("app")
template = require("./templates/table")
elements = require("./templates/elements")

ElementView = require("./element")
InfoView = require("./info")
KeyView = require("./key")

class PeriodicTableView extends Backbone.View
  elements: []

  template: template

  events: ->
    isTouch = "ontouchstart" of window
    _events =
      "iostap #close-info": "defocus"
      "swipeleft":          "next"
      "swiperight":         "previous"

    _events[if isTouch then "touchstart" else "mousedown"] = "savePosition"
    _events[if isTouch then "touchmove" else "mousemove"] = "savePosition"

    return _events

  initialize: ->
    @render()
    console.log Backbone.history.fragment
    if Backbone.history.fragment is "" and !@el.classList.contains "focused"
      app.router.navigate Backbone.history.fragment, true

  ready: ->
    @el.querySelector("#elements").innerHTML = elements(app.elementCollection)
    @el.parentNode.classList.add "ready"

    for el, i in @el.querySelectorAll(".el")
      @elements.push new ElementView
        el: el
        model: app.elementCollection.findWhere "Number": +el.dataset.number

  render: ->
    @$el.html @template()

    @infoView = new InfoView el: "#info"
    @keyView = new KeyView el: "#header"


  savePosition: (e) ->
    point = e.touches?[0] or e
    @pos = [
      point.clientX,
      point.clientY
    ]

  focus: (key, value) ->
    current = sofar = 0
    filter = {}
    filter[key] = value
    total = app.elementCollection.where(filter).length

    do @declass

    @el.classList.add "focus-#{key.toLowerCase()}"
    @el.classList.add "focus"

    app.elementCollection
      .each (model) =>
        if model.get(key) is value and value
          model.trigger "focus"
          model.trigger "show", 400, current, =>
            sofar++
            @el.classList.add "focused" if sofar is total
          current++
        else
          model.trigger "hide", 400, [].concat @pos

    clearTimeout @timeout if @timeout
    @timeout = setTimeout( =>
      @infoView.render(key, value)
    , 300)

  defocus: ->
    do @declass

    clearTimeout @timeout if @timeout

    for el in @el.querySelectorAll ".active-focus"
      el.classList.remove "active-focus"

    app.elementCollection
      .each (model) =>
        model.trigger "show"

    @infoView.hide()

  declass: ->
    @el.removeAttribute "class"

    for clone in @el.querySelectorAll ".clone"
      clone.parentNode.removeChild clone

  next: ->

  previous: ->


module.exports = PeriodicTableView
