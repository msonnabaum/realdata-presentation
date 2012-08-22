requirejs.config {
  paths: {
    lib: '../lib'
  }
  shim: {
    'zepto': {
       exports: ->
         #If we are using Zepto this is important, as Zepto is not AMD compliant.
         return @Zepto
    }
    'showdown': {
      exports: 'Showdown'
    }
    'reveal': {
      exports: 'Reveal'
    }
    'lib/highlight': {
      exports: 'hljs'
    }
    'lib/classList': {
      exports: 'classList'
    }
  }
}

define (require, exports, module) ->
  Preso = require "preso"

  p = new Preso()

  Reveal = require "reveal"
  Reveal.initialize {
    # Display controls in the bottom right corner
    controls: true

    # Display a presentation progress bar
    progress: true

    # If true; each slide will be pushed to the browser history
    history: true

    # Enable keyboard shortcuts for navigation
    keyboard: true

    # Loops the presentation, defaults to false
    loop: false

    # Flags if mouse wheel navigation should be enabled
    mouseWheel: true

    # Apply a 3D roll to links on hover
    rollingLinks: false

    # UI style
    theme: 'default' # default/neon

    # Transition style
    transition: 'default' # default/cube/page/concave/linear(2d)
  }


  hljs = require 'lib/highlight'
  hljs.initHighlightingOnLoad()
