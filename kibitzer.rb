$:.unshift(File.expand_path('lib', __FILE__))
$root_path = File.dirname(File.absolute_path(__FILE__))

require 'cinch'
require 'require_all'
require 'open-uri'
require 'rest-client'
require 'json'
require 'ostruct'
require 'yaml'
require 'hashie'
require 'recursive_open_struct'

Config = Hashie::Mash.new(YAML.load_file($root_path + '/config/config.yml')) rescue OpenStruct.new

# Initialize bot
Kibitzer = Cinch::Bot.new do
  configure do |c|
    c.nick                = Config.bot.nick
    c.nicks               = Config.bot.nicks.split(' ')
    c.user                = Config.bot.username
    c.realname            = Config.bot.realname
    c.sasl.username       = Config.sasl.username
    c.sasl.password       = Config.sasl.password
    c.server              = Config.server.hostname
    c.password            = Config.server.password
    c.port                = Config.server.port
    c.ssl.use             = Config.server.ssl
    c.max_messages        = Config.server.max_messages
    c.messages_per_second = Config.server.messages_per_second

    c.modes          = Config.server.modes.split(' ')
    c.channels       = Config.server.channels.split(' ')
    c.master         = Config.master
    c.plugins.prefix = /^\!/
  end
end

# Load Plugins
require_all "#{$root_path}/plugins/**/*.rb"

## Start the bot  IF NOT IRB/RIPL
unless defined?(IRB) || defined?(Ripl)
  Kibitzer.start
end