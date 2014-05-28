path = require 'path'
fs = require 'fs'
stylus = require 'stylus'

isString = (o) ->
  Object::toString.call(o) == '[object String]'

isStyl = /\.(styl|css)$/

module.exports = (options) ->
  options = {entry: options} if isString options
  contentType = options.contentType or 'text/css'
  cache = null

  render = (done) ->
    fs.readFile options.entry, (err, data) ->
      return done err if err?
      renderer = stylus(data.toString(), filename: options.entry)
      if options.includeCSS?
        renderer = renderer.set('include css', options.includeCSS)
      if options.use?
        for use in options.use
          renderer = renderer.use require(use)()
      if options.configure?
        renderer = options.configure(renderer)
      renderer.render (err, results) ->
        cache = results
        done err, results

  unless options.watch == false
    dirname = path.dirname(options.entry)
    fs.watch dirname, {persistent: false}, (ev, filename) ->
      render() if isStyl.test filename

  (req, res, next) ->
    res.setHeader('Content-type', contentType)
    return res.end cache if cache?

    render (err, css) ->
      return next err if err?
      res.end css
