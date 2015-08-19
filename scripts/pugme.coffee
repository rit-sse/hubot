 # Description:
#   Pugme is the most important thing in life
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot pug me - Receive a pug
#   hubot pug bomb N - get N pugs

module.exports = (robot) ->
  listenerMetadata =
    pugMe:
      id: 'pug.me'
      help: 'hubot pug me - Receive a pug'
    pugBomb:
      id: 'pug.bomb'
      help: 'hubot pug bomb N - get N pugs'
    pugCount:
      id: 'pug.count'
      help: 'hubot how many pugs are there - Returns the number of pugs'

  robot.respond /pug me/i, listenerMetadata.pugMe, (msg) ->
    msg.http("http://pugme.herokuapp.com/random")
      .get() (err, res, body) ->
        msg.send JSON.parse(body).pug

  robot.respond /pug bomb( (\d+))?/i, listenerMetadata.pugBomb, (msg) ->
    count = msg.match[2] || 5
    msg.http("http://pugme.herokuapp.com/bomb?count=" + count)
      .get() (err, res, body) ->
        msg.send pug for pug in JSON.parse(body).pugs

  robot.respond /how many pugs are there/i, listenerMetadata.pugCount, (msg) ->
    msg.http("http://pugme.herokuapp.com/count")
      .get() (err, res, body) ->
        msg.send "There are #{JSON.parse(body).pug_count} pugs."

