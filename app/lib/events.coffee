touch = "ontouchstart" of window

unless touch
  $(document).on "mousedown", (e) ->
    $(e.target).trigger "touchstart", e

Events = 
  touch: touch
  start: if touch then "touchstart" else "mousedown"
  move:  if touch then "touchmove" else "mousemove"
  end:   if touch then "touchend" else "mouseup"

module.exports = Events