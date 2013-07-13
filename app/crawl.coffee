parser = require "lib/parser"

Crawler = ->

Crawler:: = 
  queries: []
  data: []
  errors: []

  initialize: (info) ->
    @queries = [].concat info.elinks#, info.glinks

    @currentQuery = @queries.shift()

    @search()

  search: (page) ->
    $.getJSON("http://en.wikipedia.org/w/api.php?action=parse&format=json&callback=?",
      page: @currentQuery
      prop: "text"
    , (data) => @next(data))

  next: (data) ->
    if @queries.length > 0
      @parse data
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

    div = $("<div>").html(text)

    @data.push parser.parseElementData(div, data.parse.title)

module.exports = Crawler