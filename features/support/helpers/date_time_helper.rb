module Zpg
  module DateTimeHelper


    ##
    # Calculates the difference in years and month between two dates
    # Returns an array [year, month]
    # we care more about months ,
    # based on the number of months we will know how to loop through
    # the date picker and choose the right date
    def date_diff(nr_of_days_ahead)
      if nr_of_days_ahead.to_i < 0
        # .abs will return the absolute value for the nr_of_days , removing the
        # negation sign
        nr_of_days = nr_of_days_ahead.to_i.abs
        # caculate the number of months in the past
        start_date = Date.today
        start_date.to_s
        end_date = (start_date-nr_of_days).to_s
        date_to_start = start_date.strftime("%Y-%m-%d")
      else
        # caculate the number of months in the future
        start_date = Date.today.strftime("%Y-%m-%d")
        date_to_start = start_date
        end_date = Date.today.next_day(nr_of_days_ahead).strftime("%Y-%m-%d")
      end
      # Parses the given representation of date and time with the given template
      date1_parse = Date::strptime(date_to_start, "%Y-%m-%d")
      date2_parse = Date::strptime(end_date, "%Y-%m-%d")
      # we ignore day differences here
      # and then calculate the number of years by dividing that number by
      if nr_of_days_ahead.to_i < 0
        month = (date1_parse.year * 12 + date1_parse.month) -
            (date2_parse.year * 12 + date2_parse.month)
      else
        month = (date2_parse.year * 12 + date2_parse.month) -
            (date1_parse.year * 12 + date1_parse.month)
      end
      # month.divmod(12) is a shorthand for [month / 12,month % 12]
      # we care of returning just months as will not be necessary
      # to know the nr of years in this case
      month.divmod(12)[1]
    end


    ## get target date
    # target date will be used inside the date picker to
    # choose the date from the calendar
    # eg usage : Zpg.date_picker_target_date(15)[:picker_format].to_s or
    # Zpg.date_picker_target_date(15)[:filter_format].to_s
    def date_picker_target_date(nr_of_days_ahead)
      require 'active_support/core_ext/integer/inflections'

      if nr_of_days_ahead.to_i < 0
        # .abs will return the absolute value for the nr_of_days , removing the
        # negation sign
        nr_of_days = nr_of_days_ahead.to_i.abs
        # calculate the target date in the past
        end_date = Date.today.prev_day(nr_of_days).strftime("%Y-%m-%d")
      else
        # return a date in the past
        end_date = Date.today.next_day(nr_of_days_ahead.to_i).strftime("%Y-%m-%d")
      end
      # get target day
      day = Date::strptime(end_date, "%Y-%m-%d").strftime("%d")
      # get target month
      month = Date::strptime(end_date, "%Y-%m-%d").strftime("%B")
      # this will return the month Jul not the full month name
      # we need it for checking the selected date within filter
      month_filter_format = Date::strptime(end_date, "%Y-%m-%d").strftime("%b")
      # get target year
      year = Date::strptime(end_date, "%Y-%m-%d").strftime("%Y")
      # convert the date into date picker format
      # so we can use this format on web to pass it inside an xpath
      # as a query string eg : August 25, 2017
      full_picker_date_format = "#{month} #{day.to_i}, #{year}"
      # calculate filter formate date
      filter_format_date = "#{day.to_i.ordinalize} #{month_filter_format} #{year}"
      # create en empty hash where dates formats will be added
      dates_hash = {}
      # add calculated target date in date picker format to the hash
      dates_hash[:picker_format] = full_picker_date_format
      # add calculated target date in filter format to the hash
      dates_hash[:filter_format] = filter_format_date
      # return a hash with dates formats
      return dates_hash
    end


  end
end