// Description:
//   Middleware to prevent certain commands to be run in certain rooms
//
module.exports = function(robot) {

  robot.listenerMiddleware(function(robot, context, next, done){
    var id = context.listener.options.id;
    var room = context.response.envelope.room;
    var user = context.response.envelope.user;
    var cp = robot.brain.data.roomPermissions || {};
    var permissions = cp[room] || [];
    if((id === 'room.allow' || id === 'room.remove') && (robot.auth.hasRole(user, room + '-admin') || robot.auth.isAdmin(user))) {
      next(done);
    } else if (id === 'room.listCommands' || id === 'help' || permissions.indexOf(id) !== -1) {
      next(done);
    } else if (room === user.name ) { //I don't care what you and hubot do on your own time
      next(done);
    } else {
      robot.send({ room: user.name }, "Sorry you aren't allowed to run that command in " + room);
      done();
    }
  });
}