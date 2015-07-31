// Description:
//   Middleware to prevent certain commands to be run in certain rooms
//
module.exports = function(robot) {

  robot.listenerMiddleware(function(context, next, done){
    var id = context.listener.options.id;
    var room = context.response.envelope.room;
    var user = context.response.envelope.user;
    var cb = robot.brain.data.commandBlacklists || {};
    var blacklist = cb[room] || [];
    if (room === user.name ) { //I don't care what you and hubot do on your own time
      next(done);
    } else if (blacklist.indexOf(id) !== -1) {
      robot.send({ room: user.name }, "Sorry you aren't allowed to run that command in " + room);
      done();
    } else {
      next(done);
    }
  });
}