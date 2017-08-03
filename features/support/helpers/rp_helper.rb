require 'rest-client'
require 'json'
require 'pry'
module Zpg
  module RP
    URL = 'http://reportportal.domain:80/api/v1'
    TOKEN = Zpg.config.rp['uuid']
    class << self
      # Get list of all launches by project
      # @param project [String]
      # @return [Hash]
      def launches(project = Zpg.brand)
        r = RestClient.get "#{URL}/#{project}/launch?access_token=#{TOKEN}"
        JSON.parse(r.body)
      end

      # Merge launches into one
      def merge_todays(project = Zpg.brand)

        ls = launches['content'].find_all do |l|
          (['to_merge', Time.now.strftime('%Y-%m-%d')] - l['tags']).empty?
        end
        ids = ls.map { |l| l['id'] }
        start_time = Date.today.strftime("%Y-%m-%d").to_s
        description_joined = ls.map { |l| l['description'] }.join("\n==============================\n")
        params = {
            description: description_joined,
            end_time:"2100-08-03T15:51:14.136Z",
            extendSuitesDescription: 'true',
            launches: ids,
            merge_type: 'DEEP',
            name: project,
            start_time: "#{start_time}T00:00:00.000Z",
            tags: ['regression', Time.now.strftime('%Y-%m-%d'), 'merged']

        }

        RestClient.post "#{URL}/#{project}/launch/merge",
                        params.to_json,
                        {content_type: :json, accept: :json, authorization: "Bearer #{TOKEN}"}
      end



    end
  end
end
