# Description:
#   A way to ask hubot if you're an official SSE member
#
# Commands:
#   hubot is <dce> a member?

module.exports = (robot) ->
  process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0"
  
  _log = (level, message) ->
    if arguments.length is 1
      message = level
      level = 'debug'
    robot.logger[level] "[hubot-scoreboard#{ level }] #{ message }"

  robot.respond /is (.+) a member/i, (msg) ->
    name = msg.match[1]
    _log 'info', "Requesting scoreboard for #{ name }"
    searchMe msg, name, _log, (isMember) ->
      _log 'info', "Requested scoreboard, resolved membership for #{ name } to #{ isMember }"
      msg.send if isMember then "Yep, #{isMember}'s a member" else "Nope, #{ name } is not a member yet"
        
  robot.respond /am i a member/i, (msg) ->
    name = msg.message.user.name
    _log 'info', "Requesting scoreboard for #{ name }"
    searchMe msg, name, _log, (isMember) ->
      _log 'info', "Requested scoreboard, resolved membership for #{ name } to #{ isMember }"
      msg.send if isMember then "Yep, #{isMember}'s a member" else "Nope, #{ name } is not a member yet"

searchMe = (msg, dce, _log, cb) ->
  _log 'info', "Dispatching request for #{ dce }"
  finished = 0
  msg.http('https://sse.se.rit.edu')
    .path("scoreboard/api/members/#{ dce }")
    .get() (err, res, body) ->
      finished++
      _log 'info', "Got reply for #{ dce }"
      if (!err)
        resp = JSON.parse(body)
        return cb(resp.full_name)
      if (finished>=2)
        return cb(false)
    .path("scoreboard/api/high_scores")
    .get() (err, res, body) ->
      finished++
      if (!err)
        resp = JSON.parse(body)
        for elem of resp
          _log 'info', "Checking #{ dce } against #{ elem.full_name }"
          if (elem.full_name.toLower().indexOf(dce.toLower()) >= 0)
            return cb(elem.full_name)
          if (dce.toLower().indexOf(elem.full_name.toLower()) >= 0)
            return cb(elem.full_name)
      if (finished>=2)
        return cb(false)