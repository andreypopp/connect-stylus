# connect-stylus

Yet another connect/express middleware for Stylus. Don't ask me why.

## Installation

    % npm install connect-stylus

## Usage

Use with you connect or express app like this:

    var stylus = require('connect-stylus'),
        express = require('express');

    var app = express();
    app.get('/styles.css', stylus('./public/styles.styl'));

`connect-stylus` starts watching directory for changes unless you pass `{watch:
false}` as options.
