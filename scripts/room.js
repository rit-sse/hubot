// Description:
//   Sets the permissions for commands in a room
//
// Commands:
//   hubot allow command <commandId> - Allows this command in the current room
//   hubot remove command <commandId> - Remove this command in the current room
//   hubtot list commands - Displays all commands for a room sorted into enabled and disabled

module.exports = function(robot) {

  robot.respond(/allow command (.*)/i, {id: 'room.allow'}, function(msg) {
    var plugin = msg.match[1].toLowerCase();
    var room = msg.message.room;

    var roomPermissions = robot.brain.data.roomPermissions = robot.brain.data.roomPermissions || {};
    roomPermissions[room] = roomPermissions[room] || [];

    if(roomPermissions[room].indexOf(plugin) === -1){
      roomPermissions[room].push(plugin);
      robot.brain.save();

      msg.send(room + " is allowed to use " + plugin);
    } else {
      msg.send(room + " is already allowed to use " + plugin);
    }
  });

  robot.respond(/remove command (.*)/i, {id: 'room.remove'}, function(msg) {
    var plugin = msg.match[1].toLowerCase();
    var room = msg.message.room;

    var roomPermissions = robot.brain.data.roomPermissions = robot.brain.data.roomPermissions || {};
    roomPermissions[room] = roomPermissions[room] || [];

    var index = roomPermissions[room].indexOf(plugin);
    if(index === -1){
      msg.send(room + " already can't use " + plugin);
    } else {
      roomPermissions[room].splice(index, 1);
      robot.brain.save();
      msg.send(room + " can no longer use use " + plugin);
    }
  });

  robot.respond(/list commands/i, {id: 'room.listCommands'}, function(msg) {
    var room = msg.message.room;

    var roomPermissions = robot.brain.data.roomPermissions || {};
    var enabled = roomPermissions[room] || [];

    var disabled = robot.listeners.reduce(function(prev, listener){
      if(enabled.indexOf(listener.options.id) == -1){
        if(listener.options.id) {
          prev.push(listener.options.id);
        }
      }
      return prev;
    }, []);

    var message = "Enabled Commands in " + room + "\n";
    message += enabled.join('\n');
    message += "\n\nDisabled Commands in " + room + "\n";
    message += disabled.join('\n');

    robot.send({ room: msg.envelope.user.name }, message);
  });
}