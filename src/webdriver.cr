require "http/client"
require "json"
require "./webdriver/errors"
require "./webdriver/session"

module Selenium
  class Webdriver
    # :nodoc:
    CAPABILITIES = {} of Symbol => String

    getter :host, :port, :path, :tls

    def initialize(@host = "localhost", @port = 4444, @path = "/wd/hub", @tls = false)
      @client = HTTP::Client.new(host, port, tls: tls)
    end

    def get(path)
      headers = HTTP::Headers{ "Accept" => "application/json" }
      response = @client.get("#{@path}#{path}", headers)

      case response.status_code
      when 200
        JSON.parse(response.body).raw as Hash
      else
        failure(response)
      end
    end

    def post(path, body = nil)
      if body
        headers = HTTP::Headers{ "Content-Type" => "application/json; charset=UTF-8" }
        response = @client.post("#{@path}#{path}", headers, body.to_json)
      else
        response = @client.post("#{@path}#{path}")
      end

      case response.status_code
      when 200
        JSON.parse(response.body).raw as Hash
      else
        failure(response)
      end
    end

    def delete(path)
      response = @client.delete("#{@path}#{path}")
      raise Error.new(response.body) unless response.status_code == 200
      true
    end

    private def failure(response)
      if response.headers["Content-Type"].starts_with?("application/json")
        body = JSON.parse(response.body).raw as Hash
        status = body["status"] as Int
        value = body["value"] as Hash
        raise Selenium.error_class(status).new(value["message"] as String)
      end
      raise Error.new(response.body)
    end
  end
end
