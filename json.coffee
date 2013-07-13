o = {}
$("table").eq("0").find("table").remove()
$("table").eq("0").find("tr").each (i, el) ->
  $el = $(el)
  key = $el.find("th").text()
  value = $el.find("td").text()
  if key is "" or value is ""
    
    # Not applicable data
    return
  else if key is "Electron configuration"
    
    # Special case
    o[key] = value.split("\n")[0]
    o["Visual configuration"] = value.split("\n")[1].split(", ")
  else if o[key]
    
    # Multiple values
    o[key] += ", " + key
  else unless key.match(",")
    
    # Normal data
    o[key] = value
  else
    
    # Comma seperated data
    subkeys = key.split(", ")
    i = 0

    while i < subkeys.length
      o[subkeys[i]] = value.split(", ")[i]
      i++

