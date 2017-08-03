module Zpg
  module UrlHelper

    # check url has path
    def check_url_path(url_parameter)
      assert_true(is_path?(url_parameter))
    end

    # check if remote url returns an image
    def remote_image_exists?(url)
      if url.end_with? 'gif'
        return true
      else
        url = URI.parse(url)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = (url.scheme == "https")
        http.start do |http|
          return http.head(url.request_uri)['Content-Type'].start_with? 'image'
        end
      end
    end


    # @return [Response code]
    # @param [string given path]
    def get_response_code(url)
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(uri.request_uri)
      res = http.request(request)

      return res.code
    end


    # @return [Boolean]
    # @param [Given path]
    def is_path?(path)
      if current_url.include? path
        return true
      else
        return false
      end
    end

    private :is_path?
  end
end