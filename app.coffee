
###
Module dependencies.
###
express = require("express")
nodemailer = require("nodemailer")
http = require("http")
conf = require("./conf/conf.js")
app = express()
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
  mail =
    from: bod.from.replace '@', '\\@'
    replyTo: bod.from
    to: bod.to
    subject: bod.subject
    text: bod.text

  transport.sendMail mail, (error, response) ->
    if error
      res.send 500
      logger.error error
      return
    res.send 200 if !bod.redir
    res.redirect bod.redir if bod.redir

app.get "/test", (req, res) ->
  resp = "<html><body><form action='/' method='post'><input type='text' name='from'><input type='text' name='to'><input type='text' name='subject'><input type='text' name='text'><input type='submit'></form></body></html>"
  res.send resp

http.createServer(app).listen app.get("port"), ->
    console.log "Express server listening on port " + app.get("port")
