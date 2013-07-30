path = require 'path'
fs = require 'fs'
stylus = require 'stylus'
kew = require 'kew'

isString = (o) ->
  Object::toString.call(o) == '[object String]'

isStyl = /\.(styl|css)$/

module.exports = (options) ->
  options = {entry: options} if isString options
  contentType = options.contentType or 'text/css'

  rendered = undefined

  render = ->
    rendered = kew.defer()
    fs.readFile options.entry, (err, data) ->
      return rendered.reject(err) if err
      renderer = stylus(data.toString(), filename: options.entry)
      options.configure(renderer) if options.configure?
      renderer.render (err, result) ->
        return rendered.reject(err) if err
        rendered.resolve(result)

  render()

  unless options.watch == false
    dirname = path.dirname(options.entry)
    fs.watch dirname, {persistent: false}, (ev, filename) ->
      render() if isStyl.test filename

  (req, res, next) ->
    res.setHeader('Content-type', contentType)
    rendered
      .then (result) ->
        res.end(result)
      .fail next
