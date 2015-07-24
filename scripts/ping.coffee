# Description:
#   Utility commands surrounding Hubot uptime.
#
# Commands:
#   hubot ping - Reply with pong
#   hubot echo <text> - Reply back with <text>
#   hubot time - Reply with current time
#   hubot die - End hubot process

module.exports = (robot) ->
  robot.respond /PING$/i, id: 'ping.ping', (msg) ->
    robot.send { room: msg.envelope.user.name }, "PONG"

  robot.respond /ADAPTER$/i, id: 'ping.adapter', (msg) ->
    robot.send { room: msg.envelope.user.name }, robot.adapterName

  robot.respond /ECHO (.*)$/i, id: 'ping.echo', (msg) ->
    msg.send msg.match[1]

  robot.respond /TIME$/i, id: 'ping.time', (msg) ->
    robot.send { room: msg.envelope.user.name }, "Server time is: #{new Date()}"

  robot.respond /DIE$/i, id: 'ping.die', (msg) ->
    robot.send { room: msg.envelope.user.name }, "Suicide is not the answer"

