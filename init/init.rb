require 'bundler'
Bundler.require
require 'capybara'
require 'selenium-webdriver'
require 'capybara/node/matchers'
require 'capybara/rspec/matchers'
require 'rspec/core/pending'
require 'capybara/node/actions'
require 'site_prism'
require 'gmail'
require 'gmail/mailbox'
require 'gmail/message'
require 'byebug'
require 'active_support'
require 'active_support/all'
require './features/support/logger'
require 'net/https'
require 'uri'
require 'date'
require 'regexp-examples'

def platform
  if !Zpg.device.empty?
    return Zpg.device
  else
    return 'Desktop'
  end
end

puts "Environment: #{Zpg.env}, Brand: #{Zpg.brand}, Browser: #{Zpg.browser}, Url: #{Zpg.base_url} ,Platform: #{platform}"
puts "Path to the log file : tail -f #{Dir.pwd}/output/logs/main#{Socket.gethostname}--.log"
log_message "Environment: #{Zpg.env}, Brand: #{Zpg.brand}, Browser #{Zpg.browser}"
dir = File.expand_path('../../page_objects', __FILE__)
init_dir = File.expand_path('../../init', __FILE__)

FileUtils.cp_r 'config/report_portal.yml', 'report_portal.yml' if not(File.exist?('report_portal.yml'))
rp_data = YAML.load_file("#{init_dir}/#{Zpg.brand}/report_portal.yml").to_yaml
parsed = rp_data % {date: Time.now.strftime('%Y-%m-%d')}
require 'fileutils'
FileUtils.chmod(0777, 'report_portal.yml')
File.open('report_portal.yml', 'w') { |f| f.write parsed }


case Zpg.brand
  when 'zoopla'
    require 'capybara/cucumber'
    require 'capybara/dsl'
    require 'capybara/rspec/matchers'
    require 'pry'
    Dir.glob File.join(init_dir, 'zoopla', '**', '*.rb'), &method(:require)
  when 'move'
    raise 'Just sample'
  when 'primelocation'
    raise 'Just sample'
  when 'snh'
    raise 'Just sample'
  when 'zooplapro'
    raise 'Just sample'
  when 'raiden'
    raise 'Just sample'
end


###### Initialize zoopla objects
Dir.glob File.join(dir, 'zoopla', 'elements', '**', '*.rb'), &method(:require)
Dir.glob File.join(dir, 'zoopla', 'pages', '**', '*.rb'), &method(:require)
require "#{dir}/zoopla/application"
$web ||= Pages::Web::Application.new




