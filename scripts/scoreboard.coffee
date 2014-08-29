# Description:
#   A way to ask hubot if you're an official SSE member
#
# Commands:
#   hubot is <dce> a member?

module.exports = (robot) ->
  robot.respond /is (.+) (a )?member(\?)?.*/i, (msg) ->
    searchMe msg, msg.match[1], (isMember) ->
      robot.log 'info', "Requested scoreboard, resolved membership for #{ msg.match[1] } to #{ isMember }"
      msg.send isMember and "Yep" or "Nope"

searchMe = (msg, dce, cb) ->
  msg.http('https://sse.se.rit.edu/scoreboard/members/'+dce)
    .get() (err, res, body) ->
      if (err or body.indexOf('Not a member')>-1 or body.indexOf('No Such Member')>-1)
        cb false
      cb true
