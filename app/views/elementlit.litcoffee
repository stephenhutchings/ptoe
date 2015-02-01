Require the global app and the prefixer.

    app = require("app")
    prefix = require("lib/prefix")

Extend the standard Backbone View

    class ElementView extends Backbone.View

      transitionDuration: 800

      events:
        "click": "route"

Initialize the view, retaining the style of the root element and the classList
to capture the potential performance boost. Setting the initial style and
capturing the bounds help to achieve the initial animation.

      initialize: =>
        @style = @el.style
        @classList = @el.classList

        @setInitialStyles()
        @getBounds()

        @hide 0, null, => @show 800

The route() method handles the focusing and defocusing of an element based on
the "active-focus" class. This method is bound to the "focus" event that
is fired on the model in the periodic-table view.

      route: (e) ->
        if @classList.toggle "active-focus"
          app.router.navigate "element/#{@model.get("Name")}", true
        else
          app.router.navigate "", true

The hide() method will make the element disappear, and if given a position
(ie. the pointer's position), will animate away from that spot. The method
takes a callback for after the animation has occured.

      hide: (delay, pos, callback) ->

        @classList.remove "active-first"

If there is isnt an offset position, use the center of the parent element.

        if !pos
          pos = [
            @el.parentNode.offsetWidth / 2,
            @el.parentNode.offsetHeight / 2]
        else
          pos[0] -= (window.innerWidth - 1024) / 2

        @dist = Math.sqrt(
          Math.pow(pos[0] - @bounds.left, 2) +
          Math.pow(pos[1] - @bounds.top, 2))

        delay *= @dist/400

        @style.opacity = 0
        @style.pointerEvents = "none"
        @style[prefix("transitionDelay")] = "#{delay}ms"
        @style[prefix("transform")] =
          "translate3d(#{(@bounds.left - pos[0]) / 10}px,
                       #{(@bounds.top - pos[1]) / 10}px,
                       0)"
       if callback?
          clearTimeout @timeout if @timeout
          @timeout = setTimeout(=>
            callback()
          , delay + @transitionDuration)

The show() method makes the element appear, and if it is active, the element
will transform to the active position. Like hide(), show can be given a
callback after the animation.

      show: (delay, index, callback) ->
        transform = "translateZ(0)"
        delay *= @dist/400

        @classList.add "active-first" if index is 0

        if @classList.contains "active-focus"
          transform =
            "translate3d(#{-@bounds.left + 70}px,
                         #{-@bounds.top + 112 + index * 32}px,
                         0) scale(2)"

        @style.opacity = 1
        @style.pointerEvents = ""
        @style[prefix("transform")] = transform
        @style[prefix("transitionDelay")] = "#{delay}ms"

Make a clone that's high resolution to be placed over the fuzzy transformed
element.

        @makeClone index if @classList.contains "active-focus"

       if callback?
          clearTimeout @timeout if @timeout
          @timeout = setTimeout(=>
            callback()
          , delay + @transitionDuration)

The focus() method delegates to show, but adds the "active-focus" class,
which is used to determine the type of transform that occurs.

      focus: (delay) ->
        @classList.add "active-focus"
        @show delay or= 400

This method sets appropriate transitions depending on browser and the initial
opacity of the element.

      setInitialStyles: ->
        @style.opacity = 0

        setTimeout( =>
          do @withTransition
        , 1)

      withTransition: ->
        @style[prefix("transitionDuration")] = "#{@transitionDuration}ms"
        @style[prefix("transitionProperty")] = "all"

      withoutTransition: ->
        @style[prefix("transitionProperty")] = "none"

The getBounds() method finds the elements position relative to the entire
document.

      getBounds: (el) ->
        el = @el
        left = -el.offsetLeft
        top  = -el.offsetTop

        while (el = el.parentNode)
          if el.offsetLeft
            left -= el.offsetLeft
            top  -= el.offsetTop

        @bounds =
          left: -left
          top:  -top

      makeClone: (index) ->
        @clone = @el.cloneNode()
        @clone.innerHTML = @el.innerHTML
        @clone.removeAttribute "id"
        @clone.removeAttribute "style"
        @clone.classList.add "clone"
        @clone.style.marginTop = "#{index * 32}px"
        @clone.style.zIndex = index + 1
        @el.parentNode.insertBefore @clone, @el.parentNode.firstChild

Overide the views event delegation to handle listeners on the model.

      delegateEvents: ->
        super

        @model.on "focus", (delay) => @focus()
        @model.on "show", (index, callback) => @show 400, index, callback
        @model.on "hide", (pos) =>
          @hide 400, pos

      undelegateEvents: ->
        super

        @model.off "focus", => @focus()
        @model.off "show", => @show 400
        @model.off "hide", (pos) =>
          @hide 400, pos

    module.exports = ElementView
