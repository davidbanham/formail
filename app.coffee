
express = require("express")
nodemailer = require("nodemailer")
http = require("http")
conf = require("./conf/conf.js")
fs = require("fs")
app = module.exports = express()
transport = nodemailer.createTransport("SMTP", conf.mail)
logger = console

# Configuration
app.configure ->
  app.set "port", process.env.PORT or 3000
  app.use express.logger("dev")
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router

app.configure "development", ->
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )

app.configure "production", ->
  app.use express.errorHandler()


# Routes
app.post "/", (req, res) ->
  bod = req.body
  return res.send 500 if conf.whitelist.indexOf(bod.to) < 0
  send_email req, res

app.post "/authed", (req, res) ->
  return res.send 401 if req.body.auth isnt conf.auth
  send_email req, res

send_email = (req, res) ->
  bod = req.body
  bod.prepend = '' if !bod.prepend?
  mail =
    from: bod.from.replace '@', '\\@'
    replyTo: bod.from
    to: bod.to
    subject: bod.prepend+' '+ bod.subject
    text: bod.text

  transport.sendMail mail, (error, response) ->
    if error
      res.send 500
      logger.error error
      return
    res.send 200 if !bod.redir
    res.redirect bod.redir if bod.redir

app.get "/test", (req, res) ->
  fs.readFile './testpage.html', (err, data) ->
    resp = data.toString()
    res.send resp

app.get "/authed_test", (req, res) ->
  fs.readFile './authed_test.html', (err, data) ->
    resp = data.toString()
    res.send resp

app.listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")
