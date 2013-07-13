Prefix = ->
  @init()

Prefix:: =
  init: ->
    @vendor = @getVendor()

  getVendor: ->
    emptyStyle = document.createElement("div").style

    for vendor in ["t", "webkitT", "MozT", "msT", "OT"]
      transform = vendor + "ransform"
      return vendor.substr(0, vendor.length-1) if transform of emptyStyle

    false

  prefix: (style) ->

    return @[style] if @[style]
    return false if @vendor is false
    return style if @vendor is ""

    @[style] = @vendor + style.charAt(0).toUpperCase() + style.substr(1)

# return singleton
myPrefix = new Prefix()

module.exports = (style) -> myPrefix.prefix style