app = require "application"

$ ->
  app.initialize ->
    Backbone.history.start()
    window.app = app