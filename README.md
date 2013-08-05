# connect-stylus

Yet another connect/express middleware for Stylus. Don't ask me why.

## Installation

    % npm install connect-stylus

## Usage

Use with your connect or express app like this:

    var stylus = require('connect-stylus'),
        express = require('express');

    var app = express();
    app.get('/styles.css', stylus({
      entry: './public/styles.styl',
      use: ['nib', 'normalize']
    }));

`connect-stylus` starts watching directory for changes unless you pass `{watch:
false}` as an option.

If you want to configure Stylus rendering, you can pass a function which does
that as `configure` option.
