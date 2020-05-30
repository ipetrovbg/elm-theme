'use strict';

require('./index.html');
import "./style.css";

var Elm = require('./Main.elm').Elm;

var app = Elm.Main.init({
    node: document.getElementById('main')
});
