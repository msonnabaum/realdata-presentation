define 'preso', (require, exports, module) ->
  Showdown = require "showdown"
  $ = require "zepto"

  class Preso
    constructor: ->
      @get 'slides.md', (text) =>
        # Treat any line starting with % as a speaker note.
        text = text.replace /^\%(.*)\n/gm, "<aside class='notes'>\$1</aside>\n"

        html = (new Showdown.converter()).makeHtml text
        output = ""
        for slide in html.split(new RegExp(/<hr \/>/))
          continue if slide is ""
          output += @createSlide(slide)

        $em = $('.slides').append output

        # Add the fragment class for elements within a slide that has the fragment
        # class, except the first one.
        $(el).addClass('fragment') for el in @getFragmentableElements()

    get: (url, callback) ->
      request = new XMLHttpRequest()
      request.open 'GET', url, false
      request.send()
      if request.status is 200
        callback request.responseText

    getFragmentableElements: ->
      $sections = $('section.fragment')
      ret = []
      for section in $sections
        $fragment_elements = $(section).find('*')
        for el in $fragment_elements[1..$fragment_elements.length]
          $el = $(el)
          if el.nodeName isnt "ASIDE" and
              el.nodeName in @fragmentableElements() and
              !/^\s*$/.test $el.text()
            ret.push el
        ret[1..ret.length]

    fragmentableElements: ->
      ["H1"
       "H2"
       "H3"
       "H4"
       "LI"
       "P"
       "A"]

    createSlide: (contents) ->
      # If the first element is a paragraph, treat it as a list of classes.
      div = document.createElement 'div'
      div.innerHTML = contents
      first = div.children[0]
      classes = []
      if first.nodeName is 'P'
        slide_metadata = first.textContent.split " "
        for item in slide_metadata
          switch item[0]
            when "." then classes.push item.replace(".", "")
            when "#" then id = item.replace "#", ""

        class_str = classes.join " "

        # Remove the metadata node.
        div.removeChild first
        contents = div.innerHTML

      id ||= classes[0] || ""

      "<section data-state=\"#{id}\" id=\"#{id}\" class=\"hbox #{class_str}\" data-markdown>#{contents}</section>"

    findElement: (selector, context) ->
      div = document.createElement 'div'
      div.innerHTML = context
      el = div.querySelectorAll selector
      el[0]
