# Description:
#   A way to ask hubot if you're an official SSE member
#
# Commands:
#   hubot is <dce> a member?

Fuse = require "fuse"

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
      _log 'info', "Got members response for #{ dce }."
      finished++
      if (!err)
        resp = JSON.parse(body)
        return cb(resp.full_name)
      if (finished>=2)
        _log 'info', "Memberships had no entry for #{ dce }."
        return cb(false)
    .path("scoreboard/api/high_scores")
    .get() (err, res, body) ->
      _log 'info', "Got high scores response."
      finished++
      if (!err)
        resp = JSON.parse(body)
        _log 'info', body
        options = {
          keys: ['full_name'],
          id: 'full_name'
        }
        f = new Fuse(resp, options)
        result = f.search(dce)
        if (result.length > 0)
          cb(result[0])
      if (finished>=2)
        _log 'info', "High scores had no entry for #{ dce }."
        return cb(false)