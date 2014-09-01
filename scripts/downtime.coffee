# Description:
#   Check about when the last time the bot went down was and for approximately how long
#
# Commands:
#   hubot downtime - Display the last date the bot went down, and for about how long it was down for

module.exports = (robot) ->
  _log = (level, message) ->
    if arguments.length is 1
      message = level
      level = 'debug'
    robot.logger[level] "[hubot-downtime-#{ level }] #{ message }"
    
  starttime = new Date();
  lasttime = null;
  
  robot.brain.on 'save', () ->
    if !lasttime #Hold off loading this until first save, so we know data is loaded into the brain
      lasttime = new Date(robot.brain.data.timestamp)
      _log 'info', "Loaded prior timestamp #{lasttime} as last save time."
    robot.brain.data.timestamp = new Date()
  
  
  robot.respond /downtime$/i, (msg) ->
    if (lasttime)
      msg.send timeDiff("I went down at approximately #{lasttime}. I was down for ", lasttime, starttime);
    else
      msg.send "My memory shows no record of going down."


numPlural = (num) ->
  if num != 1 then 's' else ''

timeDiff = (prefix, start, now) ->
  uptime_seconds = Math.floor((now - start) / 1000)
  intervals = {}
  intervals.day = Math.floor(uptime_seconds / 86400)
  intervals.hour = Math.floor((uptime_seconds % 86400) / 3600)
  intervals.minute = Math.floor(((uptime_seconds % 86400) % 3600) / 60)
  intervals.second = ((uptime_seconds % 86400) % 3600) % 60
  
  elements = []
  for own interval, value of intervals
    if value > 0
      elements.push value + ' ' + interval + numPlural(value)
  if elements.length > 1
    last = elements.pop()
    response = elements.join ', '
    response += ' and ' + last
  else
    response = elements.join ', '
  
  return prefix + response + '.'
