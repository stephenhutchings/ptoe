parser = 
  parseElementData: (div, title) ->
    object = {}

    # Remove child tables
    $("table", div).eq("0").find("table").remove()

    # For each row
    $("table", div).eq("0").find("tr").each (i, el) ->
      $el = $(el)
      key = $el.find("th").text()
      value = $el.find("td").text()
      
      # Not applicable data
      if key is "" or value is ""
        return

      # Special case
      else if key is "Electron configuration"
        object[key] = value.split("\n")[0]
        object["Visual configuration"] = value.split("\n")[1].split(", ")

      # Multiple values
      else if object[key]
        object[key] += ", " + key

      # Comma seperated data
      else if key.match(",")
        for subkey, i in key.split(", ")
          object[subkey] = value.split(", ")[i]

      # Normal data
      else 
        object[key] = value

    object

  parseInfoData: (div, title) ->
    # detag these bad boys
    $("a, span", div).each (i, el) ->
      el.outerHTML = el.textContent

     div.contents().each ->
        if @nodeType is 8
          $(this).remove()

    # remove those pesky edit notes and useless space
    div.html div.html().replace(/\[edit\]/gi, "")
    div.html div.html().replace(/[\s|\n]+/gi, " ")

    # remove all of these suckers
    $("sup, sub, img, table, div", div).remove()

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

    # clear some attributes
    div.contents().each ->
      @outerHTML = "" if @textContent is ""
      $(@).removeAttr("style")
          .removeAttr("class")
          .removeAttr("id")
          .removeAttr("title")
          .removeAttr("scope")

    object =
      title: title
      html: div.html()

module.exports = parser