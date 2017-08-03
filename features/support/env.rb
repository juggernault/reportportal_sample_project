$VERBOSE = nil
require 'rubygems'
require 'rspec/expectations'
require 'rspec/core'
require 'capybara/rspec'
require 'capybara/rspec/matchers'
require 'capybara/node/matchers'
require 'test/unit/assertions'
require 'capybara/poltergeist'
require './features/support/config'
require './init/init'
require './features/support/logger'
require './features/support/browser'
include Test::Unit::Assertions

ENV['BROWSER'] ||= 'chrome'
ENV['TEST_ENV'] ||= 'prod'
ENV['TEST_BRAND'] ||= 'zoopla'
ENV['IN_BROWSER'] ||= 'TRUE'

# Add appropriate system web drivers to PATH
# Different environment delimiters: windows - ';' others - ':'
delimiter = Zpg.os == :windows ? ';' : ':'
ENV['PATH'] = ENV['PATH'] + delimiter + File.expand_path("../../../drivers/#{Zpg.os}", __FILE__)

Browser.init

Capybara.configure do |config|
  config.app_host = "https://#{Zpg.base_url}"
  config.default_selector = :css
end

if $headless_server.nil?
  if !ENV['IN_BROWSER']
    require 'headless'
    # allow display autopick (by default)
    # allow each headless to destroy_at_exit (by default)
    # allow each process to have their own headless by setting reuse: false
    # $headless_server = Headless.new(reuse: true)
    $headless_server = Headless.new(reuse: true, destroy_at_exit: false)
    $headless_server.start

    log_message("Process[#{Process.pid}] started headless server display: #{$headless_server.display}")
    log_message(Capybara.default_driver, "default driver" + "######################################")
  end
end


at_exit do
  unless $headless_server.nil?
    log_message("Process[#{Process.pid}] destroying headless server on display: #{$headless_server.display}")
    $headless_server.destroy
  end
end

AfterConfiguration do
  window = Capybara.current_session.driver.browser.manage.window
  window.resize_to(1250, 1000)
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end

World(RSpec::Matchers)