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

    # remove comments
    div.contents().each ->
      $(@).remove() if @nodeType is 8
          

    # remove those pesky edit notes and useless space
    div.html div.html().replace(/\[edit\]/gi, "")

    # remove all of these suckers
    $("sup, sub, img, table, div, .gallery", div).remove()

    # get the eq of the first occurance of
    # any title and remove proceeding content
    eq = Infinity
    h2s =
      ["Notes", "See also", "References", "Further reading", "External Links", "Bibliography"]

    $("h2", div).each ->
      for h2 in h2s
        eq = $(@).index() if @textContent is h2 and $(@).index() < eq

    while eq < div.contents().length - 1 and div.children().get(eq)
      div.children().get(eq).outerHTML = ""

    # clear some attributes
    $("*", div).each ->
      @outerHTML = "" if @textContent is ""
      $(@).removeAttr("style")
          .removeAttr("class")
          .removeAttr("id")
          .removeAttr("title")
          .removeAttr("scope")

    # remove redundant white-space
    while div.html().match(/[\s|\n][\s|\n]+/)
      div.html div.html().replace(/[\s|\n]+/gi, " ")

    object =
      "title": title
      "html": div.html()

module.exports = parser