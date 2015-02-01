app = require("app")

class KeyView extends Backbone.View

  events:
    "click .key-item": "route"
    "click .key-switch-list .key-item": "switch"
    "click #colophon": "about"

  initialize: ->

  route: (e) ->
    el = e.currentTarget

    return if !el.dataset.focus

    focus = el.dataset.focus.split(", ")

    if el.classList.toggle "active-focus"
      app.router.navigate "#{focus[1]}/#{focus[0]}", true
    else
      app.router.navigate "", true

  switch: (e) ->
    el = e.currentTarget
    index = Array.prototype.indexOf.call el.parentNode.childNodes, el

    target = @el.querySelectorAll(".key-group-container").item(index)

    for child in @el.querySelectorAll(".key-active")
      child.classList.remove "key-active"

    el.classList.add "key-active"
    target.classList.add "key-active"

  about: (e) ->
    el = e.currentTarget

    if el.classList.toggle "active-focus"
      app.router.navigate "#about", true
    else
      app.router.navigate "", true



module.exports = KeyView
