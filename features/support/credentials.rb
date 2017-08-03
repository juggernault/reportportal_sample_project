require 'yaml'

class Credentials
  def self.load
    @@username = nil
    @@password = nil

    def self.username
      @@username
    end

    def self.password
      @@password
    end

    credentials_file = File.dirname(__FILE__) + "/credentials.yml"

    if ENV['NO_AUTH_REQUIRED'].to_i.zero? then
      if ENV['AUTH_USER'] && ENV['AUTH_PASS'] then
        @@username = ENV['AUTH_USER']
        @@password = ENV['AUTH_PASS']
      elsif File.exist?(credentials_file) then
        doc = YAML.load_file(credentials_file)
        @@username = doc[ENV['TEST_BRAND']]['username']
        @@password = doc[ENV['TEST_BRAND']]['password']
        raise "Could not get basic auth credentials from config." unless @@username && @@password
      else
        raise "Could not get basic auth credentials. Please provide a username and password for basic auth for qa/staging."
      end
    end
  end
end

Credentials.load
