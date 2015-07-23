# Description:
#   Utility commands surrounding Hubot uptime.
#
# Commands:
#   hubot ping - Reply with pong
#   hubot echo <text> - Reply back with <text>
#   hubot time - Reply with current time
#   hubot die - End hubot process

module.exports = (robot) ->
  robot.respond /PING$/i, (msg) ->
    robot.send { room: msg.envelope.user.name }, "PONG"

  robot.respond /ADAPTER$/i, (msg) ->
    robot.send { room: msg.envelope.user.name }, robot.adapterName

  robot.respond /ECHO (.*)$/i, (msg) ->
    msg.send msg.match[1]

  robot.respond /TIME$/i, (msg) ->
    robot.send { room: msg.envelope.user.name }, "Server time is: #{new Date()}"

  robot.respond /DIE$/i, (msg) ->
    robot.send { room: msg.envelope.user.name }, "Suicide is not the answer"

