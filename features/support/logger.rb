require 'logger'
require 'socket'

Dir::mkdir('output', 0777) if not File.directory?('output')
Dir::mkdir('output/logs', 0777) if not File.directory?('output/logs')

$LOG ||= Logger.new("#{Dir.pwd}/output/logs/main#{Socket.gethostname}--#{ENV['THREAD']}.log")
$LOG_WARN ||= Logger.new("#{Dir.pwd}/output/logs/warn#{Socket.gethostname}--#{ENV['THREAD']}.log")
$LOG_USER ||= Logger.new("#{Dir.pwd}/output/logs/registered_users.log")


def log_message (message,arg1='',arg2='')
  $LOG.info("#{message} #{arg1} #{arg2}")
end

def log_user(message,arg1='',arg2='')
  $LOG_USER.info("#{message} #{arg1} #{arg2}")
end

def warn_message (message,arg1='',arg2='')
  $LOG_WARN.warn("#{message} #{arg1} #{arg2}")
end

def debug_message (message,arg1='',arg2='')
  $LOG.debug("#{message} #{arg1} #{arg2}")
end