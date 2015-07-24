// Description:
//   Sets the permissions for commands in a room
//
// Commands:
//   hubot allow command <command id> - Allows this command in the current room
//   hubot remove command <command id > - Remove this command in the current room

module.exports = function(robot) {

  robot.respond(/allow command (.*)/i, {id: 'channel.allow'}, function(msg) {
    var plugin = msg.match[1].toLowerCase();
    var room = msg.message.room;

    var channelPermissions = robot.brain.data.channelPermissions = robot.brain.data.channelPermissions || {};
    channelPermissions[room] = channelPermissions[room] || [];

    if(channelPermissions[room].indexOf(plugin) === -1){
      channelPermissions[room].push(plugin);
      robot.brain.save();

      msg.send(room + " is allowed to use " + plugin);
    } else {
      msg.send(room + " is already allowed to use " + plugin);
    }
  });

  robot.respond(/remove command (.*)/i, {id: 'channel.allow'}, function(msg) {
    var plugin = msg.match[1].toLowerCase();
    var room = msg.message.room;

    var channelPermissions = robot.brain.data.channelPermissions = robot.brain.data.channelPermissions || {};
    channelPermissions[room] = channelPermissions[room] || [];

    var index = channelPermissions[room].indexOf(plugin);
    if(index === -1){
      msg.send(room + " already can't use " + plugin);
    } else {
      channelPermissions[room].splice(index, 1);
      robot.brain.save();
      msg.send(room + " can no longer use use " + plugin);
    }
  });
}