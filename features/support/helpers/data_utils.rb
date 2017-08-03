require 'faker'
module Zpg
  module DataUtils

    def generate_random_string
      o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
      string = (0...15).map { o[rand(o.length)] }.join
      return string
    end

    def generate_name
      Faker::Name.unique.name
    end

    def generate_address
      # currently using faker we can only generate the US addresses, we can customise it using locale from faker
      Faker::Address.zip
    end

    def generate_phone_number
      Faker::Number.number(11)
    end

    def generate_sentence(sentence_count=4)
      Faker::Lorem.paragraph(sentence_count)
    end

  end
end