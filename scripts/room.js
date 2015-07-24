// Description:
//   Sets the permissions for commands in a room
//
// Commands:
//   hubot allow command <commandId> - Allows this command in the current room
//   hubot remove command <commandId> - Remove this command in the current room
//   hubtot list commands - Displays all commands for a room sorted into enabled and disabled

module.exports = function(robot) {

  var commands = robot.listeners.map(function(l){
    return l.options.id;
  });

  var defaults = robot.brain.data.defaultCommands = ['room.allow', 'help', 'room.list-commands', 'room.remove'];

  robot.respond(/allow command (.*)/i, {id: 'room.allow'}, function(msg) {
    var commandId = msg.match[1];
    var room = msg.message.room;

    var roomPermissions = robot.brain.data.roomPermissions = robot.brain.data.roomPermissions || {};
    roomPermissions[room] = roomPermissions[room] || defaults.slice(0);

    if(roomPermissions[room].indexOf(commandId) === -1){
      if(commands.indexOf(commandId) !== -1){
        roomPermissions[room].push(commandId);
        robot.brain.save();

        msg.send(room + " is allowed to use " + commandId);
      } else {
        msg.send(commandId + " is not an available command.  run `list commands` to see the list.");
      }
    } else {
      msg.send(room + " is already allowed to use " + commandId);
    }
  });

  robot.respond(/remove command (.*)/i, {id: 'room.remove'}, function(msg) {
    var commandId = msg.match[1];
    var room = msg.message.room;

    var roomPermissions = robot.brain.data.roomPermissions = robot.brain.data.roomPermissions || {};
    roomPermissions[room] = roomPermissions[room] || defaults.slice(0);

    var index = roomPermissions[room].indexOf(commandId);
    if(index === -1){
      msg.send(room + " already can't use " + commandId);
    } else if(defaults.indexOf(commandId) !== -1){
      msg.send("Why on earth would you want to remove this command? Stahp.")
    } else {
      roomPermissions[room].splice(index, 1);
      robot.brain.save();
      msg.send(room + " can no longer use use " + commandId);
    }
  });

  robot.respond(/list commands/i, {id: 'room.list-commands'}, function(msg) {
    var room = msg.message.room;

    var roomPermissions = robot.brain.data.roomPermissions || {};
    var enabled = roomPermissions[room] || defaults.slice(0);

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