system = require('system');

if (system.args.length != 3) {
    console.log("Usage: render.js url filename");
    phantom.exit(1);
} 
var url=system.args[1]
var filename=system.args[2]

var page = require('webpage').create();
page.viewportSize = { width: 1080, height: 1920 };
page.open(url, function() {
  setTimeout(function(){ 
    page.render(filename);
    phantom.exit();
  }, 5000); 
});
