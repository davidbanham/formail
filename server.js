// Include the CoffeeScript interpreter so that .coffee files will work
var coffee = require('coffee-script');

// Include our application file
var app = require('./app.coffee');

// Start the server
app.listen(3000);
