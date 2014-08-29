# Description:
#   A way to ask hubot if you're an official SSE member
#
# Commands:
#   hubot is <dce> a member?

module.exports = (robot) ->
  robot.respond /is ((.+) a member|(.+) member)/i, (msg) ->
    name = msg.match[1] or msg.match[2]
    robot.log 'info', "Requesting scoreboard for #{ name }"
    searchMe msg, name, (isMember) ->
      robot.log 'info', "Requested scoreboard, resolved membership for #{ name } to #{ isMember }"
      msg.send isMember and "Yep, #{name}'s a member" or "Nope, #{ name } is not a member yet"

searchMe = (msg, dce, cb) ->
  msg.http('https://sse.se.rit.edu/scoreboard/members/'+dce)
    .get() (err, res, body) ->
      if (err or body.indexOf('Not a member')>-1 or body.indexOf('No Such Member')>-1)
        cb false
      cb true
