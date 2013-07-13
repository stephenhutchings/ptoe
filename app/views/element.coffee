application = require("application")
prefix      = require("lib/prefix")

class ElementView extends Backbone.View

  transitionDuration: 800

  events:
    "click": "route"

  initialize: =>
    # iscroll says performance boost
    @style = @el.style

    @setInitialStyles()
    @getBounds()

    @hide 0, null, => @show 800

  # route() handles the selection and deselection of an element
  # based on the "active-sort" class

  route: (e) ->
    if @el.classList.toggle "active-sort"
      application.router.navigate "element/#{@model.get("atom")}", true
    else
      application.router.navigate "", true

    false


  # hide() will make the element disappear, and if given a position
  # ie. the pointer's position, will animate away from that spot
  # hide() takes a callback for after the animation has occured

  hide: (delay, pos, callback) ->
    @style.pointerEvents = "none"
    @style.boxShadow = "none"
    @style.backgroundImage = "none"

    @el.classList.remove "active-first"

    # if there is isnt an offset pos, use the center of the parent element
    if !pos
      pos = [@el.parentNode.offsetWidth / 2, @el.parentNode.offsetHeight / 2]

    clearTimeout @timeout if @timeout
    @timeout = setTimeout(=>
      @style[prefix("transform")] =
        "translate3d(#{(@bounds.left - pos[0]) / 10}px,
                     #{(@bounds.top - pos[1]) / 10}px,
                     0)"
      @style.opacity = 0
      @style.display = "block"
      callback() if callback
    , Math.random() * delay)

  # show() makes the element appear, and if it is active
  # the element will transform to the active position
  # Like hide, show can be given a callback after the animation

  show: (delay, index, callback) ->
    translate = ""
    opacityFactor = 1
    @el.classList.add "active-first" if index is 0

    if @el.classList.contains "active-sort"
      @style.boxShadow = "none"
      opacityFactor = (10 - index) / 5#20
      translate =
        "translate3d(#{-@bounds.left + 73}px,
                     #{-@bounds.top + 212 + index * 36}px,
                     0) scale(#{100/48})"

    clearTimeout @timeout if @timeout
    @timeout = setTimeout(=>
      @style.opacity = 1 * opacityFactor
      @style.pointerEvents = ""
      @style.backgroundImage = ""
      @style[prefix("transform")] = translate
      
      clearTimeout @timeout if @timeout
      @timeout = setTimeout(=>
        callback() if callback
      , @transitionDuration)
    , Math.random() * delay)

  # Focus delegates to show, but activates a transform

  focus: (delay) ->
    @el.classList.add "active-sort"
    @show 400

  # sets appropriate transitions depending on browser

  setInitialStyles: ->
    @style.opacity = 0

    setTimeout( =>
      @style[prefix("transitionDuration")] = "#{@transitionDuration}ms"
      @style[prefix("transitionProperty")] = "all"
    , 1)

  # getBounds finds the elements position relative to the entire document

  getBounds: (el) ->
    el = @el
    left = -el.offsetLeft
    top  = -el.offsetTop

    while (el = el.parentNode)
      if el.parentNode
        left -= el.offsetLeft
        top  -= el.offsetTop

    @bounds =
      left: -left
      top:  -top

  # Overide the views event delegation to
  # handle listeners on the model

  delegateEvents: ->
    super

    @model.on "focus", => @focus()
    @model.on "show", (index) => @show 400, index
    @model.on "hide", (pos) =>
      @hide 400, pos

  undelegateEvents: ->
    super
    
    @model.off "focus", => @focus()
    @model.off "show", => @show 400
    @model.off "hide", (pos) =>
      @hide 400, pos

module.exports = ElementView