require 'capybara/dsl'

module Zpg
  module WaitHelper

    include Capybara::DSL

    # wait for ajax request to complete
    def wait_for_ajax
        counter = 0
        while page.execute_script("return $.active").to_i > 0
          counter += 1
          sleep(0.1)
          raise "AJAX request took longer than 20 seconds." if counter >= 400
        end
    end

    # dynamicly wait for the page to load
    # usage: Zpg.wait_for(page_has_loaded)
    def wait_for_dom_has_loaded
      Capybara.default_max_wait_time = 40
      Timeout.timeout(Capybara.default_max_wait_time) do
        loop until page_has_loaded?
      end
    end

    # @return [page status]
    def page_has_loaded?
      return page.evaluate_script('document.readyState;') == 'complete'
    end


    ## used when we just want to continue and make it visible in the code
    # this is an alternative of python pass statement (continue , brake , pass)
    # is just there is no need to log a message as this tells that
    # boolean statements that we check are how we expect
    # eg : if a && b
    #       Zpg.pass
    # we check if a and b are true so I replace to say assert_true(a) and assert_true(b)
    #      else
    #       raise "Some message #{a} and #{b}"
    #      end
    def pass
    end


  end
end
