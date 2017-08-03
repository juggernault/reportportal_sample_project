module Zpg
  module ContentHelper

    # add boolean statement for fail fast if page has content
    # @return [Boolean]
    def is_content_present?(content, count=nil)
      Capybara.default_max_wait_time = 3
      if count != nil
        if page.has_content?(content, count: count)
          begin
            return true
          ensure
            Capybara.default_max_wait_time = 40
          end
        else
          return false
        end
      else
        if page.has_content?(content)
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
    # @param [table]
    def table_has_content?(table)
      Capybara.default_max_wait_time = 3
      table.rows_hash.each do |field, value|
        if field == 'text'
          if page.has_content?(value)
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
    end


    # @return [Boolean]
    # @param [wrapper,locator,expected results]
    def element_has_text_within?(wrapper, locator, expected_content)
      Capybara.default_max_wait_time = 3
      within(wrapper) do
        if find(locator).text.include?(expected_content)
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
    # @param [locator,expected results]
    def element_has_text? locator, expected_content
      Capybara.default_max_wait_time = 3
      if find(locator).text.include?(expected_content)
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
end