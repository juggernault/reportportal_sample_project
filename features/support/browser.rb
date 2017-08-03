module Browser
  class << self
    def init
      Capybara.register_driver Zpg.browser.to_sym do |app|
        client = Selenium::WebDriver::Remote::Http::Default.new
        client.read_timeout = 60
        # if device is different than empty then set the mobile capabilities
        # Zpg.device = ENV[DEVICE_NAME]
        if !Zpg.device.empty?
          # device name from google chrome user strings
          mobile_emulation = {"deviceName" => "#{Zpg.device}"}
          caps = Selenium::WebDriver::Remote::Capabilities.chrome(
              "chromeOptions" => {"mobileEmulation" => mobile_emulation})
          Capybara::Selenium::Driver.new(app, :browser => Zpg.browser.to_sym, http_client: client, desired_capabilities: caps)
        else
          # create browser object as desktop and  run on desktop mode without
          # any mobile capabilities
          Capybara::Selenium::Driver.new(app, :browser => Zpg.browser.to_sym, http_client: client)
        end
      end
      Capybara.default_driver = Zpg.browser.to_sym
      Capybara.javascript_driver = Zpg.browser.to_sym
      Capybara.default_max_wait_time = 60
    end
  end
end


