# Description:
#   Inspect the data in redis easily
#
# Commands:
#   hubot show users - Display all users that hubot knows about

module.exports = (robot) ->
  listenerMetadata =
    id: 'storage.users'
    help: 'hubot show users - Display all users that hubot knows about'

  robot.respond /show users$/i, listenerMetadata, (msg) ->
    response = ""

    for own key, user of robot.brain.data.users
      response += "#{user.id} #{user.name}"
      response += " <#{user.email_address}>" if user.email_address
      response += "\n"

    robot.send { room: msg.envelope.user.name }, response

