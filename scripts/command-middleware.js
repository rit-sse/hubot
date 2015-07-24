module.exports = function(robot) {

  robot.listenerMiddleware(function(robot, context, next, done){
    var id = context.listener.options.id;
    var room = context.response.envelope.room;
    var cp = robot.brain.data.channelPermissions || {};
    var permissions = cp[room] || [];
    if(id == 'channel.allow' || id == 'channel.remove') {
      next(done);
    } else if (permissions.indexOf(id) !== -1) {
      next(done);
    } else {
      robot.send({ room: context.response.envelope.user.name }, "Sorry you aren't allowed to run that command in " + room);
      done();
    }
  });
}