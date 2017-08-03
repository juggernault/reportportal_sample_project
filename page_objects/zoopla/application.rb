module Pages
  module Web
    class Application
      def initialize
        @pages = {}
      end

      def email_friend
        @pages[:email_friend] ||= Pages::Web::EmailFriendPage.new
      end

    end


    module MobileApp
      class Application
        def initialize
          @pages = {}
        end
      end
    end


    module Api
      class Application
        def initialize
          @apis = {}
        end
      end
    end


  end
end
