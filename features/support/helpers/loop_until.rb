module Zpg
  module LoopUntil
    def try(number_of_times)
      count = 0 ; item_of_interest = nil
      until item_of_interest != nil || count == number_of_times
        item_of_interest = yield
        sleep 10
        count += 1
      end
    end
  end
end
