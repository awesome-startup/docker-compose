# Description:
#   Example scripts for you to examine and try out.
#
# Commands:
#   hubot http post test "{\"title\": \"xxx\", \"body\": \"xxx\", \"userId\": 1}" - Reply with http post response
#   hubot http get test - Reply with http get response
#   hubot reply test - Reply with message
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

module.exports = (robot) ->

  robot.respond /reply test/i, (res) ->
    res.reply "Reply message \n Room id: #{res.message.room}"

  robot.respond /http get test/i, (msg) ->
    msg.http("http://jsonplaceholder.typicode.com/posts/1")
      .get() (err, res, body) ->
        msg.reply "#{body}"

  robot.respond /http post test (.*)/i, (msg) ->
    data = JSON.parse msg.match[1]
    msg.http("http://jsonplaceholder.typicode.com/posts")
      .header('Content-Type', 'application/json')
      .post(data) (err, res, body) ->
        msg.reply "#{body}"

  robot.respond /reply me/i, (res) ->
    res.reply "At your service! \n Room: ##{res.message.room}"

  robot.hear /^test$/i, (res) ->
   res.send "Test? TESTING? WE DON'T NEED NO TEST, EVERYTHING WORKS!"

  robot.respond /open the (.*) doors/i, (res) ->
    doorType = res.match[1]
    if doorType is "pod bay"
      res.reply "I'm afraid I can't let you do that."
    else
      res.reply "Opening #{doorType} doors"


  robot.hear /I like pie/i, (res) ->
    res.emote "makes a freshly baked pie"


  robot.respond /lulz/i, (res) ->
    res.send res.random ['lol', 'rofl', 'lmao']


  robot.topic (res) ->
    res.send "#{res.message.text}? That's a Paddlin'"


  robot.enter (res) ->
    res.send res.random ['Hi', 'Target Acquired', 'Firing', 'Hello friend.', 'Gotcha', 'I see you']


  robot.leave (res) ->
    res.send res.random ['Are you still there?', 'Target lost', 'Searching']


  answer = process.env.HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING
  robot.respond /what is the answer to the ultimate question of life/, (res) ->
    unless answer?
      res.send "Missing HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING in environment: please set and try again"
      return
    res.send "#{answer}, but what is the question?"


  robot.respond /you are a little slow/, (res) ->
    setTimeout () ->
      res.send "Who you calling 'slow'?"
    , 60 * 1000


  annoyIntervalId = null

  robot.respond /annoy me/, (res) ->
    if annoyIntervalId
      res.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
      return
    res.send "Hey, want to hear the most annoying sound in the world?"
    annoyIntervalId = setInterval () ->
      res.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
    , 1000

  robot.respond /unannoy me/, (res) ->
    if annoyIntervalId
      res.send "GUYS, GUYS, GUYS!"
      clearInterval(annoyIntervalId)
      annoyIntervalId = null
    else
      res.send "Not annoying you right now, am I?"


  robot.router.post '/hubot/chatsecrets/:room', (req, res) ->
    room   = req.params.room
    data   = JSON.parse req.body.payload
    secret = data.secret
    robot.messageRoom room, "I have a secret: #{secret}"
    res.send 'OK'


  robot.error (err, res) ->
    robot.logger.error "DOES NOT COMPUTE"
    if res?
      res.reply "DOES NOT COMPUTE"


  robot.respond /have a soda/i, (res) ->
    # Get number of sodas had (coerced to a number).
    sodasHad = robot.brain.get('totalSodas') * 1 or 0
    if sodasHad > 4
      res.reply "I'm too fizzy.."
    else
      res.reply 'Sure!'
      robot.brain.set 'totalSodas', sodasHad+1


  robot.respond /sleep it off/i, (res) ->
    robot.brain.set 'totalSodas', 0
    res.reply 'zzzzz'