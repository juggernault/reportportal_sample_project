module Zpg
  module HooksHelper

    # there are cases when cookies disclaimer banner somehow overlaps elements in the dom
    # and makes capybara raise an exception that locator is not clickable at point because of cookies banner
    # this method will allow to close it if exist
    # The only place where can be use in the hooks is on after step witch can be really expensive for the
    # execution so , for move I will use it after I navigate to the page instead of having it to run after each step
    def close_cookies_disclaimer
      # set timeout to 0 sec
      Capybara.default_max_wait_time = 0

      # define cookie accept button as hidden
      cookie_hideen_button = "//button[contains(@class,
        'cookie-banner__button') and @aria-hidden='true']"

      # define cookie accept button not hiden
      accept_button ='button.cookie-banner__button'

      # check if accept button is present and is not hidden
      if Capybara.page.has_selector?(accept_button) &&
          !Zpg.is_xpath_present?(cookie_hideen_button)

        # accept cookies to avoid elements from the page to be overlapped by this container
        cookie_button = find(accept_button)
        cookie_button.click

        # set the timeout back to normal
        Capybara.default_max_wait_time = 40
      else
        # in case there is no need to accept cookies
        # set the timeout back to normal
        Capybara.default_max_wait_time = 40
      end
    end

  end
end