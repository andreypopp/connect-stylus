require 'coffee-errors'

express = require 'express'
supertest = require 'supertest'
stylus = require '../index.coffee'
{expect} = require 'chai'

describe 'connect-stylus', ->
  app = null

  before ->
    app = express()
    app.use '/index.css', stylus entry: "#{__dirname}/index.styl"
    app.use '/invalid.css', stylus "#{__dirname}/invalid.styl"
    app.use (err, req, res, next) -> res.end err.stack

  it 'returns rendered css', (done) ->
    supertest(app)
      .get '/index.css'
      .expect 200
      .expect 'Content-Type', /css/
      .end (err, {text}) ->
        expect(text).to.eql """
          body {
            color: #f00;
          }

          """
        done()

  it 'handles errors', (done) ->
    supertest(app)
      .get '/invalid.css'
      .expect 500
      .end (err, {text}) ->
        expect(text).to.match /^ParseError:/
        done()
