# Description:
#   Generates help commands for Hubot.
#
# Commands:
#   hubot help - Displays all of the help commands that Hubot knows about.
#   hubot help <query> - Displays all help commands that match <query>.
#
# URLS:
#   /hubot/help
#
# Notes:
#   These commands are grabbed from comment blocks at the top of each file.

helpContents = (name, commands) ->

  """
<!DOCTYPE html>
<html>
  <head>
  <meta charset="utf-8">
  <title>#{name} Help</title>
  <style type="text/css">
    body {
      background: #d3d6d9;
      color: #636c75;
      text-shadow: 0 1px 1px rgba(255, 255, 255, .5);
      font-family: Helvetica, Arial, sans-serif;
    }
    h1 {
      margin: 8px 0;
      padding: 0;
    }
    .commands {
      font-size: 13px;
    }
    p {
      border-bottom: 1px solid #eee;
      margin: 6px 0 0 0;
      padding-bottom: 5px;
    }
    p:last-child {
      border: 0;
    }
  </style>
  </head>
  <body>
    <h1>#{name} Help</h1>
    <div class="commands">
      #{commands}
    </div>
  </body>
</html>
  """

module.exports = (robot) ->
  listenerMetadata =
    id: 'help'
    help: [
      'hubot help - Displays all of the help commands that Hubot knows about.',
      'hubot help <query> - Displays all help commands that match <query>.'
    ]
  robot.respond /help\s*(.*)?$/i, listenerMetadata, (msg) ->
    cmds = robot.listeners.map (l) ->
      l.options

    filter = msg.match[1]

    if filter
      cmds = cmds.filter (cmd) ->
        [].concat(cmd.help).join('\n').match new RegExp(filter, 'i')
      if cmds.length == 0
        robot.send { room: msg.envelope.user.name }, "No available commands match #{filter}"
        return

    prefix = robot.alias or robot.name
    emit = ''
    cmds = cmds.forEach (cmd) ->
      help = [].concat(cmd.help).join('\n')
      help = help.replace /hubot/ig, robot.name
      help.replace new RegExp("^#{robot.name}"), prefix
      emit += "*#{cmd.id}*:\n#{help}\n"

    robot.send { room: msg.envelope.user.name }, emit

  robot.router.get "/#{robot.name}/help", (req, res) ->
    cmds = robot.helpCommands().map (cmd) ->
      cmd.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;')

    emit = "<p>#{cmds.join '</p><p>'}</p>"

    emit = emit.replace /hubot/ig, "<b>#{robot.name}</b>"

    res.setHeader 'content-type', 'text/html'
    res.end helpContents robot.name, emit