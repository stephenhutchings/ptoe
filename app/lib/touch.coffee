# micro library to reroute touch events regardless of pointer style

(($)->
  isTouch = "ontouchstart" of window
  allowScroll = false

  isScroll = (el) ->
    _el = el.get 0
    return true if window.getComputedStyle(_el).overflow is "scroll"
    while _el = _el.parentNode
      if _el.parentNode and window.getComputedStyle(_el).overflow is "scroll"
        return true

  events =
    start: if isTouch then "touchstart" else "mousedown"
    move:  if isTouch then "touchmove" else "mousemove"
    end:   if isTouch then "touchend" else "mouseup"

  parentIfText = (node) ->
    if "tagName" of node then node else node.parentNode

  touch = {}

  $(document).ready ->
    $(document.body).on(events.start, (e) ->
      e = e.touches[0] if isTouch
      touch.el = $(parentIfText(e.target))
      touch.el.trigger "start", e
      allowScroll = isScroll touch.el
    ).on(events.move, (e) ->
      e.preventDefault() unless allowScroll
      return unless touch.el
      touch.el.trigger "move", e
    ).on(events.end, (e) ->
      return unless touch.el
      touch.el.trigger "end", e
      touch = {}
    ).on("touchcancel", ->
      touch = {}
    )

  ["start", "move", "end"].forEach (m) ->
    $.fn[m] = (callback) ->
      @bind m, callback

)(Zepto || jQuery || whatever)
