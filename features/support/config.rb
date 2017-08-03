require 'yaml'
require_relative 'helpers/os_helper'
require_relative 'helpers/actions_helper'
require_relative 'helpers/wait_helper'
require_relative 'helpers/locator_helper'
require_relative 'helpers/content_helper'
require_relative 'helpers/data_utils'
require_relative 'helpers/url_helper'
require_relative 'helpers/loop_until'
require_relative 'helpers/hooks_helper'
require_relative  'helpers/date_time_helper'

module Zpg
  extend OSHelper
  extend ActionsHelper
  extend WaitHelper
  extend LocatorHelper
  extend ContentHelper
  extend DataUtils
  extend UrlHelper
  extend LoopUntil
  extend HooksHelper
  extend DateTimeHelper

  # Current environment
  # @return [Symbol]

  def self.env
    @env ||= (ENV['TEST_ENV'] || 'prod')
  end

  def self.env=(env)
    @env = env
  end

  def self.browser
    @browser ||= (ENV['BROWSER'] || 'chrome').to_s
  end

  def self.browser=(browser)
    @browser = browser
  end

  def self.device
    @device ||= config.send(:devices).to_s
  end

  def self.device=(device)
    @device = device
  end

  def self.brand
    @brand ||= (ENV['TEST_BRAND'] || 'zoopla')
  end

  def self.brand=(brand)
    @brand = brand
  end

  # Read the base URL from congif.yml or from the environment variable BASE_URL
  def self.base_url
    @base_url ||= (ENV['BASE_URL'] || config.send(:base_url))
  end

  # Set the base url to the given value
  def self.base_url=(base_url)
    @base_url = base_url
  end

  # Read the mobile URL from congif.yml or from the environment variable MOBILE_URL
  def self.mobile_url
    @mobile_url ||= (ENV['MOBILE_URL'] || config.send(:mobile_url))
  end

  # Set the mobile url to the given value
  def self.mobile_url=(mobile_url)
    @mobile_url = mobile_url
  end

  def self.config
    @config ||= configure
  end

  def self.configure
    @config ||= Configuration.new
    yield(@config) if block_given?
    @config
  end


  class Configuration
    attr_accessor :creds, :settings, :rp, :devices

    def initialize
      @creds = load_file(File.join(Dir.pwd, 'config', 'credentials.yml'))
      @settings = load_file(File.join(Dir.pwd, 'features', 'support', 'config.yml'))[Zpg.env][Zpg.brand]
      @rp = load_file(File.join(Dir.pwd, 'init', Zpg.brand, 'report_portal.yml'))
      @devices = YAML::load_file(File.join(Dir.pwd, 'features', 'support', 'devices.yml'))[ENV['DEVICE_NAME']]
    end

    def load_file(filename)
      YAML.load_file(filename)
    rescue Errno::ENOENT
      warn "[Warning] Can't load file #{filename}"
    end

    def method_missing(name)
      @settings[name.to_s]
    end
  end
end