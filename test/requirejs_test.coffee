{ assert, brains, Browser } = require("./helpers")


describe "require.js", ->

  before (done)->
    brains.get "/requirejs", (req, res)->
      res.send """
      <html>
        <head>
          <script data-main="/requirejs/index" src="/scripts/require.js"></script>
        </head>
        <body>
        </body>
      </html>
      """
    brains.get "/requirejs/index.js", (req, res)->
      res.send """
        require(["dependency"], function(dependency) {
          dependency()
        })
      """
    brains.get "/requirejs/dependency.js", (req, res)->
      res.send """
        define(function() {
          return function() {
            document.title = "Dependency loaded";
          }
        })
      """
    brains.ready done

  before (done)->
    @browser = new Browser()
    @browser.visit "http://localhost:3003/requirejs", done

  it "should load dependencies", ->
    assert.equal @browser.document.title, "Dependency loaded"

