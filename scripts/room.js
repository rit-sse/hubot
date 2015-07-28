// Description:
//   Sets the permissions for commands in a room
//
// Commands:
//
//   hubot enable/disable <commandId> - Enable/disable this command in the current room
//   hubot enable/disable all - Enable/disable all commands in the current room
//   hubot list commands - Displays all commands for a room sorted into enabled and disabled

module.exports = function(robot) {
  var defaults = robot.brain.data.defaultCommands = ['room.enable', 'help', 'room.list-commands', 'room.disable'];

  robot.respond(/enable (.*)/i, {id: 'room.enable'}, function(msg) {
    var commandId = msg.match[1];
    var room = msg.message.room;

    var roomPermissions = robot.brain.data.roomPermissions = robot.brain.data.roomPermissions || {};
    roomPermissions[room] = roomPermissions[room] || defaults.slice(0);

    if(roomPermissions[room].indexOf(commandId) === -1){
      var commands = robot.listeners.reduce(function(prev, l){
        if(l.options.id) {
          prev.push(l.options.id);
        }
        return prev;
      }, []);

      if(commandId === 'all'){
        roomPermissions[room] = commands;
        robot.brain.save();
        msg.send('All commands enabled in ' + room);
      } else if(commands.indexOf(commandId) !== -1){
        roomPermissions[room].push(commandId);
        robot.brain.save();
        msg.send(commandId + " is enabled in " + room);
      } else {
        msg.send(commandId + " is not an available command.  run `list commands` to see the list.");
      }
    } else {
      msg.send(commandId + " is already enabled in " + room);
    }
  });

  robot.respond(/disable (.*)/i, {id: 'room.disable'}, function(msg) {
    var commandId = msg.match[1];
    var room = msg.message.room;

    var roomPermissions = robot.brain.data.roomPermissions = robot.brain.data.roomPermissions || {};
    roomPermissions[room] = roomPermissions[room] || defaults.slice(0);

    var index = roomPermissions[room].indexOf(commandId);
    if(commandId === 'all') {
      roomPermissions[room] = defaults.slice(0);
      robot.brain.save();
      msg.send('All commands disabled in ' + room);
    } else if(index === -1){
      msg.send(commandId + " is already disabled in " + room);
    } else if(defaults.indexOf(commandId) !== -1){
      msg.send("Why on earth would you want to disable this command? Stahp.")
    } else {
      roomPermissions[room].splice(index, 1);
      robot.brain.save();
      msg.send(commandId + " is disabled in " + room);
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

    var message = "*Enabled Commands in " + room + "*\n";
    message += enabled.join('\n');
    message += "\n\n*Disabled Commands in " + room + "*\n";
    message += disabled.join('\n');

    robot.send({ room: msg.envelope.user.name }, message);
  });
}