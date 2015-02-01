# Test whether the browser can toggle classes based on rules
div = document.createElement("div")
div.classList.add "toggleRules"
div.classList.toggle "toggleRules", true

unless div.classList.contains "toggleRules"
  DOMTokenList::toggle = (klass, rule) ->
    if @contains(klass) and !rule
      @remove klass
    else if rule or !rule?
      @add klass

    @contains klass