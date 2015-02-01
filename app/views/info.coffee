app         = require("app")
prefix      = require("lib/prefix")
about       = require("./templates/about")
infoBody    = require("./templates/info-body")

class InfoView extends Backbone.View
  transitionDuration: 400
  transitionDelay: 800

  attempts: 0

  initialize: ->
    @style = @el.style
    @initializeStyles()
    @initializeScroller()

  initializeStyles: ->
    @style.opacity = 0
    @style[prefix "transitionDuration"] = "#{@transitionDuration}ms"
    @style[prefix "transitionProperty"] = "all"

  initializeScroller: ->
    @scroller =
     new IScroll @el,
      mouseWheel: true
      probeType: 3

  initializeHeaders: ->
    @headers = []

    headerElements = @el.querySelectorAll "h2"

    if headerElements
      for h2 in headerElements
        h2.className = "scrolling-header"
        before = h2.previousElementSibling || offsetTop: 0, offsetHeight: 0
        @headers.push
          el:  h2
          height: h2.offsetHeight
          min: before.offsetTop + before.offsetHeight - 1

        hr  = document.createElement( "hr")
        hr.className = "hr"
        h2.parentNode.insertBefore hr, h2.nextSibling

      @scroller.on "scroll", => @translateHeaders()

      @translateHeaders()

  render: (key, value) ->
    html = @getHTML key, value

    @style.display = "block"
    @style.opacity = 0

    model = app.elementCollection.findWhere "Name": value if key is "Name"

    clearTimeout @timeout if @timeout
    @timeout = setTimeout( =>
      @show infoBody(model: model or null, html: html, title: value)
    , if @active then @transitionDuration else 0)

  show: (html, callback) ->
    @active = true

    if @html isnt html
      @scroller.scroller.innerHTML = html
      @scroller.scrollTo 0, 0
      refresh = true
      @html = html
    else
      @scroller.scroller.innerHTML = @html

    @initializeHeaders()

    clearTimeout @timeout if @timeout
    @timeout = setTimeout( =>
      @scroller.refresh()
      @style.opacity = 1
      @translateHeaders()
    , @transitionDelay)

  hide: (callback) ->
    @active = false
    @style.opacity = 0

    clearTimeout @timeout if @timeout
    @timeout = setTimeout( =>
      @style.display = "none"
      @scroller.scroller.innerHTML = ""
    , @transitionDuration)

  translateHeaders: ->
    scrollTop = -@scroller.y

    for header, i in @headers
      next = @headers[i + 1] or min: Infinity

      # Ensure every header has a max
      header.max or header.max = next.min - header.height

      y = Math.max(Math.min(scrollTop, header.max), header.min)

      header.el.style[prefix "transform"] = "translate3d(0, #{y}px, 0)"
      header.el.classList[if y > header.min then "add" else "remove"] "solid"

      # TODO: render only within viewport
      itsAboveTheViewport = scrollTop + header.height > header.max

  getHTML: (key, value) ->
    if key is "About"
      html = about()
      value = "About"
    else
      child = app.infoCollection.findWhere "name": value

      if !child and app.infoCollection.length > 0
        html = "<p>No information about #{value} is available.</p>"
      else if child
        html = child.get("html")
      else
        html = "<p>Failed to load #{value}</p>"

    html

module.exports = InfoView
