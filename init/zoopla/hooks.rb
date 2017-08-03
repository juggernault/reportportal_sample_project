Before do |scenario|
  # reset Capybara session trying to avoid session timeout
  # as sometimes capybara gets stuck on about:blank and it doesnt know
  # hot to reset the session
  Capybara.reset_sessions!
  Zpg.delete_all_cookies
end

AfterStep() do
  Capybara.default_max_wait_time = 0.5
  if page.has_selector?('a.alerts-popup-btn-create')
    close_pop_up = find('a.alerts-popup-btn-close')
    begin
      close_pop_up.click
    ensure
      Capybara.default_max_wait_time = 40
    end
  else
    Capybara.default_max_wait_time = 40
  end
end


After do |scenario|
  # remove the basic authentication credentials from the current url
  # print current page url to get the environment information on the CI build
  if scenario.failed?
    Dir::mkdir('output', 0777) if not File.directory?('output')
    Dir::mkdir('output/screenshots', 0777) if not File.directory?('output/screenshots')
    screenshot = "./output/screenshots/FAILED_#{scenario.name.gsub(' ', '_').gsub(/[^0-9A-Za-z_]/, '')}.png"
    if page.driver.browser.respond_to?(:save_screenshot) then
      page.driver.browser.save_screenshot(screenshot)
    else
      save_screenshot(screenshot)
    end
    FileUtils.chmod(0777, screenshot)
    embed current_url, 'text/plain', current_url
    embed screenshot, 'image/png', ' Screenshot'
  end

  # Get an array of all the instance varaibles
  all_instance_variables = instance_variables

  # Set them all back to nil ready for the next test
  all_instance_variables.each do |variable|
    variable = nil
  end
end



