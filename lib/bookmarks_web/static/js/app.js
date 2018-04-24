// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
import $ from "./vendor/jquery-3.1.1.min"
//import $ from "./vendor/bootstrap"

// Some bootstrap things need this, not most thankfully, keep disabled unless required, this one might require it?
//global.jQuery = require("jquery")

// Make sure you included bootstrap js in your npm and brunch config files or this will not work
//global.bootstrap = require("bootstrap")

// Do the stuff to the existing html at page load time:
$(document).ready(() => {
    // This is optional if you want to do it on 'something other than default'
      $('[data-toggle="collapse"]').collapse()
})
