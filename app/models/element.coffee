class ElementModel extends Backbone.Model
  cssClassName: ->
    [
      @get("Category").replace(/\(|\)/g, "").replace(/\s/g, "-").toLowerCase()
      @get("Phase").toLowerCase()
      @get("Occurance")
    ].join(" ")

  cssID: ->
    "el-#{@get("Symbol").toLowerCase()}"

module.exports = ElementModel
