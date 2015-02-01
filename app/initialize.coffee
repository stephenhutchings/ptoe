app = require "app"

$ ->
  app.initialize ->
    Backbone.history.start silent: true
    window.app = app
