module Pages
  module Web
      class EmailFriendPage < SitePrism::Page

        include EmailFriendElements
        include Capybara::DSL
        include Capybara::Node::Matchers
        include Capybara::RSpecMatchers
        include Test::Unit::Assertions


        def fill_sender_data(table)
          table.rows_hash.each do |field, value|
            if field.include?'name'
              find(SENDER_NAME).set value
            elsif field.include?'email'
              find(SENDER_EMAIL).set value
            elsif field.include?'message'
              find(TEXTAREA_MESSAGE_BOX).set value
            end
          end
        end


        #BASED ON THE FACT THAT THE USER HAS THE POSIBILITY TO SEND THE EMAIL TO MORE THAN ONE FRIENDS
        #WE ARE GOING TO ITERATE AND FILL THE FRIEND'S EMAIL FIELDS AS MANY ARE DEFINED INTO THE CUCUMBER STEPS
        def fill_friends_email(number_of_friends)
         0.upto(number_of_friends.to_i) do |i|
           find(FRIEND_EMAIL + "#{i}").set 'sharlequin@zoopla.co.uk'
         end
        end

        #THE METHOD WILL CLICK ON <Tell another friend> LINK AS MANY TIMES WE ADD IN THE CUCUMBER STEPS AND
        # WILL GENERATE AS MANY EMAIL FIELDS WE ASK
        def add_a_new_friend_email_field(number_of_friends)
          1.upto(number_of_friends.to_i) do |i|
            click_link 'Tell another friend'
          end
        end
      end
    end
end
