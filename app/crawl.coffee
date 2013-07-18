parser = require "lib/parser"

Crawler = ->

Crawler:: = 
  queries: []
  data: []
  errors: []

  initialize: (info, type) ->
    if type is "info"
      @queries = [].concat info.elinks, info.glinks
    else if type is "element"
      @queries = [].concat info.elinks
    else
      return console.warn "No type given to Crawler"

    @type = type
    @currentQuery = @queries.shift()
    @search()

  search: (page) ->
    $.getJSON("http://en.wikipedia.org/w/api.php?action=parse&format=json&callback=?",
      page: @currentQuery
      prop: "text"
    , (data) => @next(data))

  next: (data) ->
    @parse data
    
    if @queries.length > 0
      setTimeout( =>
        @currentQuery = @queries.shift()
        @search()
      , 100)
    else
      console.log JSON.stringify(@data)

  parse: (data) ->
    if data.error
      return @errors.push @currentQuery

    text = data.parse.text["*"]
    title = data.parse.title

    div = $("<div>").html(text)

    if @type is "info"
      @data.push parser.parseInfoData div, title
    else if @type is "element"
      @data.push parser.parseElementData div, title

module.exports = Crawler