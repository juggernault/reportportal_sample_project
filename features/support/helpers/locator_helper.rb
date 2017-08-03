module Zpg
  module LocatorHelper

    # is xpath present within wrapper
    # @return [Boolean]
    # @param [wrapper ,xpath locator]
    def is_xpath_present_within?(tree_head_locator, xpathlocator)
      Capybara.default_max_wait_time = 3
      within(tree_head_locator) do
        if page.has_xpath?(xpathlocator)
          begin
            return true
          ensure
            Capybara.default_max_wait_time = 1
          end
        else
          return false
        end
      end
    end


    # stub return true or false if locator is present
    def is_element_present?(locator, options={:visible => true})
      Capybara.default_max_wait_time = 3
      if page.has_selector?(locator, options)
        begin
          return true
        ensure
          Capybara.default_max_wait_time = 40
        end
      else
        return false
      end
    end


    # stub return true or false if xpath is present
    def is_xpath_present?(xpath)
      Capybara.default_max_wait_time = 1
      if page.has_xpath?(xpath)
        begin
          return true
        ensure
          Capybara.default_max_wait_time = 40
        end
      else
        return false
      end
    end


    # @return [Boolean]
    # @param [wrapper,locator , int(number of appearances for locator)]
    def is_locator_displayed_n_times_within?(tree_header_locator, locator, nr_of_appearances)
      Capybara.default_max_wait_time = 3
      within(tree_header_locator) do
        if page.has_selector?(locator, count: nr_of_appearances)
          begin
            return true
          ensure
            Capybara.default_max_wait_time = 40
          end
        else
          return false
        end
      end
    end

    # @return [Boolean]
    # @param [locator , int(number of appearances for locator)]
    def is_locator_displayed_n_times?(locator, nr_of_appearances)
      Capybara.default_max_wait_time = 3
      if page.has_selector?(locator, count: nr_of_appearances)
        begin
          return true
        ensure
          Capybara.default_max_wait_time = 40
        end
      else
        return false
      end
    end

    # @return [Boolean]
    # @param [xpath expression , int(number of appearances for xpath)]
    def is_xpath_displayed_n_times?(xpath, nr_of_appearances)
      Capybara.page.document.synchronize(10) do
        Capybara.default_max_wait_time = 3
        if page.has_xpath?(xpath, count: nr_of_appearances)
          begin
            return true
          ensure
            Capybara.default_max_wait_time = 40
          end
        else
          return false
        end
      end
    end


    # @return [Boolean]
    # @return [button name]
    def is_button_displayed?(button_name)
      Capybara.default_max_wait_time = 3
      if page.has_button?(button_name)
        begin
          return true
        ensure
          Capybara.default_max_wait_time = 40
        end
      else
        return false
      end
    end

    # @return [Boolean]
    # @param [linkname]
    def is_link_present?(link_name)
      Capybara.default_max_wait_time = 1
      if page.has_link?(link_name)
        begin
          return true
        ensure
          Capybara.default_max_wait_time = 40
        end
      else
        return false
      end
    end

    # @return [Array] of x,y position of element
    def element_position(element)
      Capybara.evaluate_script <<-EOS
        function() {
          var element = document.evaluate('#{element.path}', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
          var rect = element.getBoundingClientRect();
          return [rect.left, rect.top];
        }();
      EOS
    end

    # @return [Array] of x,y of element size
    def element_size(element)
      Capybara.evaluate_script <<-EOS
        function() {
          var element = document.evaluate('#{element.path}', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
          return [element.offsetWidth, element.offsetHeight];
        }();
      EOS
    end

    # @param [locator, coordinates array of numbers [123, 123.455]
    def is_positioned?(element,coordinates)
      assert_true(Zpg.element_position(element).uniq.sort == coordinates.uniq.sort,"Found #{element.native.location} expected #{coordinates}")
    end


    # @param [locator, size array of numbers [123, 123.455]
    def has_size?(element,size)
      assert_true(Zpg.element_size(element).uniq.sort == size.uniq.sort,"Found #{element.native.size} expected #{size}")
    end


  end
end