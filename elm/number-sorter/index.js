require('./index.html');
require('./styles.scss');

var Elm = require('./numbersorter.elm');
var mountNode = document.getElementById('main');

var app = Elm.Main.embed(mountNode);