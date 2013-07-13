Crawler = ->

Crawler:: = 
  queries: []
  data: []
  errors: []

  initialize: (info) ->
    @queries = [].concat(info.elinks, info.glinks)

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

    # detag these bad boys
    $("a, span", div).each (i, el) ->
      el.outerHTML = el.textContent

     div.contents().each ->
        if @nodeType is 8
          $(this).remove()

    # remove those pesky edit notes
    div.html div.html().replace(/\[edit\]/gi, "")
    div.html div.html().replace(/[\s|\n]+/gi, " ")

    # get the eq of the first occurance of
    # any title and remove proceeding content
    eq = Infinity
    titles =
      ["Notes", "See also", "References", "Further reading", "External Links", "Bibliography"]

    $("h2", div).each (i, el) ->
      for title in titles
        eq = $(el).index() if el.textContent is title and $(el).index() < eq

    while eq < div.contents().length - 1 and div.children().get(eq)
      div.children().get(eq).outerHTML = ""

    # remove all of these suckers
    $("sup, sub, img, table", div).remove()

    # clear some attributes
    div.contents().each ->
      @outerHTML = "" if @textContent is ""
      $(@).removeAttr("style")
          .removeAttr("class")
          .removeAttr("id")
          .removeAttr("title")
          .removeAttr("scope")

    # voila
    @data.push 
      title: data.parse.title
      html: div.html()

module.exports = Crawler