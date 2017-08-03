module Zpg
  module ActionsHelper
    # Scroll to any element/section
    # @param element [Capybara::Node::Element, SitePrism::Section]
    def scroll_to(element)
      element = element.root_element if element.respond_to?(:root_element)
      Capybara.evaluate_script <<-EOS
        function() {
          var element = document.evaluate('#{element.path}', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
          window.scrollTo(0, element.getBoundingClientRect().top + pageYOffset - 200);
        }();
      EOS
    end


    # click on locator using java script
    def java_script_click_to(element)
      element = element.root_element if element.respond_to?(:root_element)
      Capybara.evaluate_script <<-EOS
        function() {
          var element = document.evaluate('#{element.path}', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
          element.click();
        }();
      EOS
    end

    # scroll into view
    def scrollIntoView(element)
      page.execute_script("$('#{element}').get(0).scrollIntoView();")
      Zpg.wait_for_ajax
    end

    # Click by point coordinates
    # @param x [Integer]
    # @param y [Integer]
    def click_by_coordinates(x, y)
      Capybara.execute_script("document.elementFromPoint(#{x}, #{y}).click()")
    end

    # Refresh page
    def refresh_page
      Capybara.page.driver.browser.navigate.refresh
    end

    # Mouse hover element/section
    def hover_over(element)
      element = element.root_element if element.respond_to?(:root_element)
      Capybara.page.driver.browser.action.move_to(element.native).perform
    end

    # coose value from dropdown list
    # usage : Zpg.choose_from_drop_down(PROPERTY_TYPE,FLATS)
    def choose_from_drop_down(locator, value, type='css')
      find(type.to_sym, locator).find(:option, "#{value}").select_option
      Zpg.wait_for_ajax
    end


    # click on a link within a wrapper
    def click_link_within(wrapper, link)
      within(wrapper) do
        find(:link, link).click
      end
    end

    # type text
    def type_text(locator, input_text, type='css')
      find(type.to_sym, locator).set input_text
      Zpg.wait_for_ajax
    end


    #click on within
    def click_on_within(tree_head_locator, locator, type='css')
      within(tree_head_locator) do
        find(type.to_sym, locator).click
      end
    end

    # click on xpath by indenting
    def click_on_using_indentation(xpath, indentation_value)
      find(:xpath, "#{xpath}#{indentation_value}']").click
    end

    # hover item within wrapper
    def hover_within(wrapper, locator, type)
      within(wrapper) do
        find(type.to_sym, locator).hover
      end
    end

    # click on any text
    def click_on_text(text_to_click)
      find(:xpath, "//*[contains(text(),'#{text_to_click}')]").click
    end

    # click on label for
    def click_on_label_for(label)
      find(:xpath, "//label[@for='#{label}']").click
    end

    # choose random value from a drop down
    def choose_random_option_from_drop_down(type, locator)
      options = find(type, locator).all(:option)
      if options.last.text.include? 'My address is not listed'
        tmp_options = options.drop(1)
        # remove my address is not listed option
        tmp_options2 = tmp_options.first options.size - 1
        # select from what is left
        tmp_options2[rand(tmp_options2.count)].select_option
      elsif options.count <= 2
        options[1].select_option
      else
        tmp_options3 = options.drop(1)
        tmp_options3[rand(tmp_options3.count)].select_option
      end
    end


    def save_cookies
      cookies = Capybara.page.driver.browser.manage.all_cookies.to_yaml
      File.open(shared_path + '/cookies.yml', 'w') { |f| f.write cookies }
    end

    def delete_all_cookies
      Capybara.page.driver.browser.manage.delete_all_cookies
    end

    def populate_cookies
      cookies = YAML.load(File.open(shared_path + '/cookies.yml'))
      cookies.each { |cookie| Capybara.page.driver.browser.manage.add_cookie cookie }
    end

    def shared_path
      if File.directory?('/dev/shm')
        '/dev/shm'
      else
        FileUtils.mkdir_p('output/config') unless File.exists?('output/config')
        'output/config'
      end
    end

    private :shared_path
  end
end
