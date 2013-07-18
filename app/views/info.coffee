application = require("application")
prefix      = require("lib/prefix")

class InfoView extends Backbone.View
  transitionDuration: 400
  transitionDelay: 800

  initialize: ->
    @style = @el.style
    @initializeStyles()
    @initializeScroller()

  initializeStyles: ->
    @style.opacity = 0
    @style[prefix "transitionDuration"] = "#{@transitionDuration}ms"
    @style[prefix "transitionProperty"] = "all"

  initializeScroller: ->
    @scroller = new IScroll @el,
      mouseWheel: true
      probeType: 3

    @scroller.on "scroll", =>
      @translateHeaders()

  initializeHeaders: ->
    @headers = []
    headerElements = @el.querySelectorAll "h2"

    for h2 in headerElements
      h2.className = "scrolling-header"
      before = h2.previousElementSibling || document.createElement("div")
      @headers.push
        el:  h2
        height: h2.offsetHeight
        min: before.offsetTop + before.offsetHeight + h2.offsetHeight / 2

      hr  = document.createElement("hr")
      hr.className = "hr"
      h2.insertAdjacentElement "afterend", hr

    @translateHeaders()

  render: (html) ->
    @style.display = "block"
    @style.opacity = 0
    console.log "render"

    clearTimeout @timeout if @timeout
    @timeout = setTimeout( =>
      @show html
    , if @active then @transitionDuration else 0)

  show: (html, callback) ->
    @active = true

    if @html isnt html
      @scroller.scroller.innerHTML = html
      @scroller.refresh()
      @scroller.scrollTo 0, 0
      @html = html
    else
      @scroller.scroller.innerHTML = @html

    @initializeHeaders()

    clearTimeout @timeout if @timeout
    @timeout = setTimeout( =>
      @style.opacity = 1
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
    for header, i in @headers
      unless header.max
        previous = @headers[i + 1]
        header.max = if previous then previous.min - header.height else Infinity
        
      y = Math.max(Math.min(-@scroller.y, header.max), header.min)

      header.el.classList[if y > header.min then "add" else "remove"] "solid" 

      header.el.style[prefix("transform")] =
        "translate3d(0,#{y}px,0)"

module.exports = InfoView