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

      initialize: ->
        @style = @el.style
        @classList = @el.classList

        @setInitialStyles()
        @getBounds()

For the initial hide, we use the centre of the parent as the offset position.

        @hide 0, [
          @el.parentNode.offsetWidth / 2,
          @el.parentNode.offsetHeight / 2
        ], => @show 800

The route() method handles the focusing and defocusing of an element based on
the "active-focus" class. This method is called on the element's click event.

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

        clearTimeout @timeout if @timeout
        @timeout = setTimeout(=>
          callback() if callback
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

        clearTimeout @timeout if @timeout
        @timeout = setTimeout(=>
          callback() if callback
        , delay + @transitionDuration)

The focus() method delegates to show, but adds the "active-focus" class,
which is used to determine the type of transform that occurs.

      focus: ->
        @classList.add "active-focus"

This method sets appropriate transitions depending on browser and the initial
opacity of the element.

      setInitialStyles: ->
        @style.opacity = 0
        @style.zIndex = @model.get("Number") + 1

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

This makeClone() takes the focus index of the element and constructs a clone
that will appear over the actual element. This is because the rendering of the
source element can appear to be fuzzy, due to the transforms that are applied.

      makeClone: (index) ->
        @clone = @el.cloneNode()
        @clone.innerHTML = @el.innerHTML
        @clone.removeAttribute "id"
        @clone.removeAttribute "style"
        @clone.classList.add "clone"
        @clone.style.marginTop = "#{index * 32}px"
        @clone.style.zIndex = index + app.elementCollection.length
        @el.parentNode.insertBefore @clone, @el.parentNode.firstChild

We overide the view's event delegation to handle event listeners on the model.
The context is passed to the listeners to avoid wrapping in anonymous
functions.

      delegateEvents: ->
        super

        @model.on
          "focus": @focus
          "show": @show
          "hide": @hide
        , this

      undelegateEvents: ->
        super

        @model.off
          "focus": @focus
          "show": @show
          "hide": @hide
        , this

    module.exports = ElementView
