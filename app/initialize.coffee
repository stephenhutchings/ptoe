app = require "application"

$ ->
  app.initialize ->
    Backbone.history.start silent: true
    window.app = app